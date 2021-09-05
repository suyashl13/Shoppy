from django.http import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from .models import Product, Category
from .serializers import CategorySerializer, ProductSerializer
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def produt_route(request: WSGIRequest):
    """
        @route : /products/
        @description : A route to get and upload products.
        @type : [ GET ]
        @access : {GET : PUBLIC, POST: PRIVATE}
    """
    if request.method == 'GET':
        active_categories = CategorySerializer(Category.objects.filter(is_active=True), many=True,
                                               context={'request': request}).data
        res = []

        for active_category in active_categories:
            active_category['products'] = ProductSerializer(
                Product.objects.filter(category__name=active_category['name'], is_active=True, is_available=True),
                many=True,
                context={'request': request}).data
            res.append(active_category)

        return JsonResponse(res, safe=False)
