from django.http.response import JsonResponse
from ...helpers.auth_helper import AuthHelper
from django.core.handlers.wsgi import WSGIRequest
from ..models import Cart, CourierDelivery
from ...users.models import Subdealer
from ..helper import get_child_cart_items, check_subdealer
from ..serializers import CartSerializer, CourierDeliverySerializer
from django.views.decorators.csrf import csrf_exempt
from django.http import QueryDict
from ...users.serializer import UserSerializers
from ...users.models import CustomUser


# Views
@csrf_exempt
def subdealer_cart_route(request: WSGIRequest) -> JsonResponse:
    """
        @route : /carts/
        @description : A route to create a new cart or get exsisting carts.
        @type : [ POST, GET ]
        @allowed_roles : [ Customer, Subdealer, Superuser, Staff ]
        @access : PRIVATE
    """
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    if check_subdealer(usr):
        return JsonResponse({"ERR": 'subdealer deactivated'}, status=401)

    if request.method == 'GET':
        # If user is subdealer then show him orders at his assigned pincodes.
        if usr.is_subdealer:
            subdealer_pincodes = [pin_code.strip() for pin_code in
                                  str(Subdealer.objects.get(user=usr).pincodes).split(',')]
            subdealer_carts = CartSerializer(Cart.objects.filter(pin_code__in=subdealer_pincodes).order_by('-id'),
                                             many=True).data
            res = []

            for cart in subdealer_carts:
                cart = dict(cart)
                if cart['user'] is not None:
                    cart['user'] = UserSerializers(CustomUser.objects.get(id=cart['user'])).data
                    try:
                        cart['assigned_to'] = UserSerializers(CustomUser.objects.get(id=cart['assigned_to'])).data
                    except:
                        pass
                    cart['cart_items'] = get_child_cart_items(cart['id'], request)
                    res.append(cart)

            return JsonResponse(res, safe=False, status=200)
        else:
            return JsonResponse({'ERR': 'Unauthorized'}, status=401)
    else:
        return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=405)


@csrf_exempt
def subdealer_cart_id_route(request: WSGIRequest, cart_id: int) -> JsonResponse:
    """
        @route : /carts/<int:id>/
        @description : A route to update carts and add cart_items to cart.
        @type : [ POST, GET, PUT ]
        @roles : [ Subdealer ]
        @access : PRIVATE
    """

    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)
    usr = auth_result['user']

    if check_subdealer(usr):
        return JsonResponse({"ERR": 'subdealer deactivated'}, status=401)

    if request.method == 'PUT':
        if usr.is_subdealer:
            try:
                request_body = QueryDict(request.body).dict()
                cart = Cart.objects.get(id=cart_id)

                # Check weather subdealer is delivering product in assigned pin_code
                try:
                    subdealer = Subdealer.objects.get(user=usr)
                    if not str(cart.pin_code).strip() in [str(subd_pincode).strip() for subd_pincode in
                                                          str(subdealer.pincodes).split(',')]:
                        return JsonResponse({'ERR': 'Cant deliver product at this pincode'})

                except Exception as e:
                    return JsonResponse({'ERR': str(e)}, status=400)

                for attribute, value in request_body.items():
                    if attribute == 'is_delivered':
                        setattr(cart, attribute, True) \
                            if (value == 'true' or value == 'True') else setattr(cart,
                                                                                 attribute,
                                                                                 False)
                    if attribute == 'assigned_to':
                        try:
                            if cart.is_canceled or cart.is_delivered or cart.is_verified:
                                return JsonResponse({'ERR': 'Unable to assign cancelled / delivered cart.'}, status=401)
                            assigned_user = CustomUser.objects.get(id=int(value))
                            setattr(cart, attribute, assigned_user)
                            cart.order_status = 'Dispatched'
                        except:
                            return JsonResponse({'ERR': 'assigned user is invalid.'})
                    else:
                        setattr(cart, attribute, value)

                cart.save()
                res = CartSerializer(cart).data
                res['courier_details'] = None
                res['user'] = UserSerializers(CustomUser.objects.get(id=res['user'])).data
                res['assigned_to'] = UserSerializers(CustomUser.objects.get(id=res['assigned_to'])).data
                res['cart_items'] = get_child_cart_items(cart.id, request)
                return JsonResponse(res, status=200)
            except Exception as e:
                return JsonResponse({'ERR': str(e)}, status=400)

    elif request.method == 'DELETE':
        try:
            if not (usr.is_staff or usr.is_subdealer or usr.is_superuser):  # User is customer
                cart_to_del = Cart.objects.get(id=cart_id)
                if cart_to_del.user == usr:
                    cart_to_del.delete()
                    return JsonResponse({'INFO': 'Cart Deleted Successfully'})
                else:
                    return JsonResponse({'ERR': 'Unauthorized'}, status=401)
            else:
                return JsonResponse({'ERR': 'Unauthorized'}, status=401)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)


@csrf_exempt
def subdealer_courier_cart_id_route(request: WSGIRequest, cart_id: int) -> JsonResponse:
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)
    usr = auth_result['user']

    if check_subdealer(usr):
        return JsonResponse({"ERR": 'subdealer deactivated'}, status=401)

    if request.method == 'POST':
        try:
            request_body = request.POST

            courier = CourierDelivery()
            cart = Cart.objects.get(id=cart_id)
            courier.cart = cart

            # Check weather subdealer is delivering product in assigned pin_code
            try:
                subdealer = Subdealer.objects.get(user=usr)
                if not str(cart.pin_code).strip() in [str(subd_pincode).strip() for subd_pincode in
                                                      str(subdealer.pincodes).split(',')]:
                    return JsonResponse({'ERR': 'Cant deliver product at this pincode'})

            except Exception as e:
                return JsonResponse({'ERR': str(e)}, status=400)

            for attr, val in request_body.items():
                if attr.split('_')[0] == 'courier':
                    setattr(courier, attr, val)

            cart.order_status = "Sent via Courier"
            courier.save()
            cart.save()
            res = CartSerializer(cart).data
            res['courier_details'] = CourierDeliverySerializer(courier).data
            res['user'] = UserSerializers(CustomUser.objects.get(id=res['user'])).data
            res['assigned_to'] = None
            res['cart_items'] = get_child_cart_items(cart.id, request)
            return JsonResponse(res, status=200)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)
