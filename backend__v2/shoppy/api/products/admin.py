from django.contrib import admin
from .models import Product, Category

# Register your models here.
model_list = (Product, Category)

for model in model_list:
    admin.site.register(model)
