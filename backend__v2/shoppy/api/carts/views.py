from django.http.response import JsonResponse
from ..helpers.auth_helper import AuthHelper
from django.core.handlers.wsgi import WSGIRequest
from .models import Cart, CartItem
from .helper import add_item_to_cart, get_child_cart_items, get_absolute_boolean
from .serializers import CartSerializer
from django.views.decorators.csrf import csrf_exempt
from django.http import QueryDict


# Views
@csrf_exempt
def cart_route(request: WSGIRequest) -> JsonResponse:
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

    if request.method == 'POST':
        # Create a new cart if user is customer.
        if not (usr.is_staff or usr.is_subdealer or usr.is_superuser):
            new_cart = Cart(user=usr)
            post_data = request.POST.dict()
            try:
                for attribute, value in post_data.items():
                    if attribute in ['shipping_address', 'pin_code', 'delivery_phone']:
                        setattr(new_cart, attribute, value)

                # If user doesn't provides any custom address then give default delivery address.
                if new_cart.shipping_address is None:
                    new_cart.shipping_address = usr.address
                if new_cart.pin_code is None:
                    new_cart.pin_code = usr.pincode
                if new_cart.delivery_phone is None:
                    new_cart.delivery_phone = usr.phone

                # Set order status as assigned and save cart
                new_cart.order_status = 'Assigned'
                new_cart.save()
                return JsonResponse(CartSerializer(new_cart).data)
            except Exception as e:
                return JsonResponse({'ERR': str(e)}, status=500)
        else:
            return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    elif request.method == 'GET':
        # Show previous orders if user is customer.
        if not (usr.is_staff or usr.is_subdealer or usr.is_superuser):
            try:
                usr_carts = CartSerializer(
                    Cart.objects.filter(user=usr).order_by('-id'), many=True).data
                res = []

                for cart in usr_carts:
                    cart = dict(cart)
                    cart['cart_items'] = get_child_cart_items(cart['id'], request)
                    res.append(cart)

                return JsonResponse(res, safe=False, status=200)
            except Exception as e:
                print(e)
                return JsonResponse({'ERR': str(e)}, status=500)
        else:
            return JsonResponse({'ERR': 'Unauthorized'}, status=401)
    else:
        return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=405)


@csrf_exempt
def cart_id_route(request: WSGIRequest, cart_id: int) -> JsonResponse:
    """
        @route : /carts/<int:id>/
        @description : A route to update carts and add cart_items to cart.
        @type : [ POST, GET, PUT ]
        @roles : [ Customer, Subdealer, Superuser, Staff ]
        @access : PRIVATE
    """

    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)
    usr = auth_result['user']

    if request.method == 'POST':
        # If user is customer add items to cart.
        if not (usr.is_staff or usr.is_subdealer or usr.is_superuser):

            try:
                quantity = int(request.POST['quantity'])
                product = int(request.POST['product'])
            except Exception as e:
                return JsonResponse({'ERR': 'Missing ' + str(e)}, status=400)

            return add_item_to_cart(request=request, cart_id=cart_id, owner_user=usr, quantity=quantity,
                                    product_id=product)

        else:
            return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'PUT':
        if not (usr.is_staff or usr.is_subdealer or usr.is_superuser):  # User is customer
            try:
                request_body = QueryDict(request.body).dict()
                cart = Cart.objects.get(id=cart_id)

                # Validations
                if cart.user != usr:
                    return JsonResponse({'ERR': 'Unauthorized'}, status=401)

                # Verify or cancel
                for attribute, value in request_body.items():
                    if cart.is_canceled:
                        return JsonResponse({'ERR': 'Already canceled.'}, status=400)

                    if cart.is_verified:
                        return JsonResponse({'ERR': 'Already verified.'}, status=400)

                    if attribute == 'is_cancelled':

                        # Validations
                        # TODO: 4Hr validation

                        if cart.assigned_to is not None:
                            return JsonResponse({'ERR': 'Cart already dispatched.'}, status=401)

                        cart.is_canceled = get_absolute_boolean(value)
                        cart.order_status = 'Canceled'

                        # Add product back to inventory when cart is canceled
                        cancelled_cart_items = CartItem.objects.filter(cart=cart)
                        for cart_item in cancelled_cart_items:
                            inv_product = cart_item.product
                            inv_product.available_stock = inv_product.available_stock + cart_item.quantity
                            if inv_product.is_available is False:
                                inv_product.is_available = True
                            inv_product.save()

                    elif attribute == 'is_verified':
                        if not cart.is_delivered:
                            return JsonResponse({'ERR': 'Verification can be done only after delivery.'}, status=400)

                        cart.is_verified = get_absolute_boolean(value)
                        cart.order_status = 'Delivered'

                cart.save()
                return JsonResponse(CartSerializer(cart).data, status=200)
            except Exception as e:
                return JsonResponse({'ERR': str(e)}, status=400)

        else:
            return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    return JsonResponse({'ERR': "Invalid method"}, status=403)
