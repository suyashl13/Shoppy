from django.contrib import admin
from .models import Cart, CartItem, CourierDelivery

# Register your models here.
model_list = (Cart, CartItem, CourierDelivery)

for model in model_list:
    admin.site.register(model)
