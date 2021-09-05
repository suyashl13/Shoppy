from .models import Product, Category
from rest_framework.serializers import ModelSerializer, HyperlinkedModelSerializer, ImageField


class ProductSerializer(ModelSerializer):
    product_image = ImageField(max_length=None, allow_empty_file=True, required=False)

    class Meta:
        model = Product
        fields = '__all__'


class CategorySerializer(ModelSerializer):
    class Meta:
        model = Category
        fields = ('name', 'is_active', 'display_url', 'date_time_created', 'date_time_updated')
