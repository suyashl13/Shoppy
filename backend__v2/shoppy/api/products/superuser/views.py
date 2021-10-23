from django.http import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from ..models import Product, Category
from ..serializers import CategorySerializer, ProductSerializer
from django.views.decorators.csrf import csrf_exempt

from ...helpers.auth_helper import AuthHelper
from ...users.models import CustomUser, Subdealer
from ...users.serializer import UserSerializers, SubdealerSerializer


@csrf_exempt
def superuser_product_route(request: WSGIRequest):
    """
        @route : superuser/products/
        @description : A route to get products.
        @type : [ GET ]
        @access : {GET : PUBLIC, POST: PRIVATE}
    """
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        all_categories = CategorySerializer(Category.objects.all(), many=True, context={'request': request}).data
        all_products = ProductSerializer(Product.objects.all(), many=True, context={'request': request}).data

        product_res = []

        for product in all_products:
            try:
                product['category'] = CategorySerializer(Category.objects.get(id=product['category'])).data['name']
            except:
                product['category'] = None

            try:
                product['addedby_subdealer'] = SubdealerSerializer(
                    Subdealer.objects.get(id=product['addedby_subdealer'])).data
                product['addedby_subdealer']['user'] = UserSerializers(CustomUser.objects.get(
                    id=product['addedby_subdealer']['user']
                )).data
            except:
                product['addedby_subdealer'] = None

            product_res.append(product)

        return JsonResponse({
            'categories': all_categories,
            'products': product_res
        })
