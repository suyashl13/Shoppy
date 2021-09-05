from .models import Cart, CartItem
from .serializers import CartSerializer, CartItemSerializer
from ..products.serializers import ProductSerializer
from ..products.models import Product, Category
from django.http.response import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from ..users.models import CustomUser, Subdealer


def get_child_cart_items(cart_id, request: WSGIRequest) -> list:
    cart_items = CartItem.objects.filter(cart__id=cart_id)
    result = []
    for cart_item in cart_items:
        cart_itm = dict(CartItemSerializer(cart_item).data)
        product_dict = ProductSerializer(Product.objects.get(pk=cart_itm['product']), context={'request': request}).data
        product_dict['category'] = Category.objects.get(id=product_dict['category']).name
        cart_itm['product'] = product_dict
        result.append(cart_itm)
    return result


def add_item_to_cart(owner_user, cart_id: int, product_id: int, quantity: int, request: WSGIRequest) -> JsonResponse:
    try:
        product = Product.objects.get(id=product_id)
        cart = Cart.objects.get(id=cart_id)
    except Exception as e:
        return JsonResponse({'ERR': str(e)}, status=401)

    # Perform validations
    if cart.user != owner_user:
        return JsonResponse({'ERR': 'Unauthorized user attemting to add items in cart.'}, status=401)

    if product.available_stock < quantity:
        cart.delete()
        return JsonResponse({'ERR': 'Insufficient stock.'}, status=401)

    if product.available_stock < 0:
        product.is_available = False
        product.save()

    if not product.is_available:
        return JsonResponse({'ERR': 'Product is not available.'}, status=401)

    # Add item to cart
    try:
        product.available_stock = product.available_stock - quantity
        product.save()

        cart.discount_price = 0  # TODO: Calculate appropriate value and assign it
        cart.tax_amount = 0  # TODO: Calculate appropriate value and assign it
        cart.subtotal = cart.subtotal + (product.price * quantity)
        cart.save()

        CartItem(cart=cart, quantity=quantity, amount=product.price * quantity, product=product).save()
        serialized_cart = dict(CartSerializer(cart).data)
        serialized_cart['cart_items'] = get_child_cart_items(cart.id, request)
        if product.available_stock == 0:
            product.is_available = False
            product.save()

        return JsonResponse(serialized_cart, safe=False, status=200)

    except Exception as e:
        return JsonResponse({'ERR': str(e)}, status=500)


def get_absolute_boolean(stringy_boolean: str) -> bool:
    if stringy_boolean == 'true' or stringy_boolean == 'True':
        return True
    else:
        return False


def check_subdealer(user: CustomUser) -> bool:
    current_subdealer = Subdealer.objects.get(user=user)
    return not current_subdealer.is_active
