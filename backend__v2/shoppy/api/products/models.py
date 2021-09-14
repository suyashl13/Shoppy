from django.db import models
from ..users.models import Subdealer


# Create your models here.
class Category(models.Model):
    name = models.CharField(max_length=20)
    is_active = models.BooleanField()

    display_url = models.FileField(upload_to='category/', blank=False, null=False)

    date_time_created = models.DateTimeField(auto_now=True)
    date_time_updated = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class Product(models.Model):
    title = models.CharField(max_length=80)
    price = models.FloatField()

    unit = models.CharField(max_length=8)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, blank=True, null=True)
    description = models.TextField(max_length=250, null=True, default="")
    discount = models.FloatField()
    is_available = models.BooleanField(default=True)

    product_image = models.FileField(upload_to='product/', blank=False, null=False)

    vendor_name = models.CharField(max_length=50)
    addedby_subdealer = models.ForeignKey(Subdealer, on_delete=models.SET_NULL, null=True, blank=True, default=None)

    available_stock = models.PositiveIntegerField()
    is_active = models.BooleanField()

    tax_percentage = models.FloatField()
    base_price = models.FloatField(default=0.0)

    date_time_created = models.DateTimeField(auto_now=True)
    date_time_updated = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title + ' (' + str(self.id) + ')'
