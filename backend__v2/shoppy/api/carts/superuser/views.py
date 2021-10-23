from django.http import JsonResponse

from ..helper import get_child_cart_items
from ..models import Cart, CourierDelivery
from ..serializers import CartSerializer, CourierDeliverySerializer
from django.core.handlers.wsgi import WSGIRequest

from ...helpers.auth_helper import AuthHelper
from ...users.models import CustomUser
from ...users.serializer import UserSerializers


def superuser_route(request: WSGIRequest):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        all_carts = CartSerializer(Cart.objects.all(), many=True).data

        res = []
        for cart in all_carts:
            if cart['user'] is not None:
                try:
                    cart['user'] = UserSerializers(CustomUser.objects.get(id=cart['user'])).data
                except:
                    cart['user'] = None

            if cart['assigned_to'] is not None:
                try:
                    cart['assigned_to'] = UserSerializers(CustomUser.objects.get(id=cart['assigned_to'])).data
                except:
                    cart['assigned_to'] = None

            cart['cart_items'] = get_child_cart_items(cart_id=cart['id'], request=request)
            
            try:
                cart['courier_details'] = CourierDeliverySerializer(CourierDelivery.objects.get(cart__id=cart['id'])).data
            except Exception:
                cart['courier_details'] = None
            res.append(cart)

        return JsonResponse(res, safe=False)
