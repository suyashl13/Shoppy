from rest_framework.serializers import ModelSerializer
from .models import Cart, CartItem, CourierDelivery


class CartSerializer(ModelSerializer):
    class Meta:
        model = Cart
        fields = '__all__'


class CartItemSerializer(ModelSerializer):
    class Meta:
        model = CartItem
        fields = '__all__'


class CourierDeliverySerializer(ModelSerializer):
    class Meta:
        model = CourierDelivery
        fields = '__all__'
