from api.carts.helper import get_child_cart_items
from api.carts.models import Cart
from api.carts.serializers import CartSerializer


def get_subdealer_carts(subdealer_pincodes, request):
    subdealer_pincodes = [pin_code.strip() for pin_code in
                          str(subdealer_pincodes).split(',')]
    subdealer_carts = CartSerializer(Cart.objects.filter(pin_code__in=subdealer_pincodes).order_by('-id'),
                                     many=True).data

    res = []
    for subdealer_cart in subdealer_carts:
        subdealer_cart['cart_items'] = get_child_cart_items(subdealer_cart['id'], request=request)
        res.append(subdealer_cart)
    return res
