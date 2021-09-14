from django.http.response import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from ...helpers.auth_helper import AuthHelper
from ..models import Cart
from ..serializers import CartSerializer
from ..helper import get_child_cart_items
from ...users.models import CustomUser
from ...users.serializer import UserSerializers
from django.http import QueryDict
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def staff_cart_route(request: WSGIRequest):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Validations
    if not usr.is_active:
        return JsonResponse({'ERR': 'Staff Deactivated.'}, status=400)

    if not usr.is_subdealer_staff:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        try:
            deliverable_carts = CartSerializer(Cart.objects.filter(assigned_to=usr, is_verified=False), many=True).data
            res = []
            for deliverable_cart in deliverable_carts:
                deliverable_cart['cart_items'] = get_child_cart_items(deliverable_cart['id'], request)
                deliverable_cart['user'] = UserSerializers(CustomUser.objects.get(id=deliverable_cart['user'])).data
                res.append(deliverable_cart)
            return JsonResponse(res, safe=False)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)

    else:
        return JsonResponse({'ERR': 'Invalid HTTP Request.'})


@csrf_exempt
def staff_cart_id_route(request: WSGIRequest, cart_id: int):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Validations
    if not usr.is_active:
        return JsonResponse({'ERR': 'Staff Deactivated.'}, status=400)

    if not usr.is_subdealer_staff:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'PUT':
        try:
            request_body = QueryDict(request.body).dict()
            cart = Cart.objects.get(id=cart_id)

            for attr, val in request_body.items():
                if attr == 'is_delivered':
                    if val == 'true':
                        val = True
                        cart.order_status = "Pending Verification"
                    else:
                        val = False

                setattr(cart, attr, val)

            cart.save()

            res = CartSerializer(cart).data
            res['user'] = UserSerializers(CustomUser.objects.get(id=res['user'])).data
            res['cart_items'] = get_child_cart_items(res['id'], request)

            return JsonResponse(res)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=404)
