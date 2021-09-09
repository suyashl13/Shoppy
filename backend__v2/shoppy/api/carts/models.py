from django.db import models
from ..users.models import CustomUser
from ..products.models import Product


# Create your models here.
class Cart(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True)

    is_delivered = models.BooleanField(default=False)
    assigned_to = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='assigned_to', blank=True)
    is_verified = models.BooleanField(default=False)

    is_canceled = models.BooleanField(default=False)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)

    payment_method = models.CharField(max_length=12, null=True, blank=True)
    subtotal = models.FloatField(default=0)

    order_status = models.CharField(max_length=15)
    discount_price = models.FloatField(default=0)

    tax_amount = models.FloatField(default=0)
    shipping_address = models.CharField(max_length=150, blank=True, null=True)

    pin_code = models.CharField(max_length=8, blank=True, null=True)
    delivery_phone = models.CharField(max_length=12, blank=True, null=True)


class CourierDelivery(models.Model):
    courier_name = models.CharField(max_length=50)
    courier_tracking_id = models.CharField(max_length=50)
    cart = models.ForeignKey(Cart, on_delete=models.SET_NULL, null=True)


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField()

    amount = models.FloatField()

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)

    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True)
