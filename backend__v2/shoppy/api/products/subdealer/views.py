from django.http.response import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from ...helpers.auth_helper import AuthHelper
from django.views.decorators.csrf import csrf_exempt
from ..models import Product, Category
from ..serializers import ProductSerializer, CategorySerializer
from ...users.models import Subdealer
from django.http import QueryDict


@csrf_exempt
def products_subdealers_route(request: WSGIRequest) -> JsonResponse:
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)
    usr = auth_result['user']

    if not usr.is_subdealer:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        try:
            subdealer_products = Product.objects.filter(addedby_subdealer__user=usr)
            return JsonResponse(
                {'products': ProductSerializer(subdealer_products, many=True, context={'request': request}).data,
                 'categories': CategorySerializer(Category.objects.filter(is_active=True),
                                                                  many=True).data
                 },
                safe=False)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)

    if request.method == 'POST':
        try:
            request_body = request.POST
            new_product = Product()
            for attr, val in request_body.items():
                if attr in ["product_image", "title", "price", "unit", "description", "discount", "is_available",
                            "vendor_name", "available_stock", "tax_percentage", "base_price", "category"]:
                    if attr in ["discount", "tax_percentage"]:
                        setattr(new_product, attr, float(val))
                    else:
                        setattr(new_product, attr, val)

            new_product.product_image = request.FILES['product_image']
            new_product.is_active = False
            new_product.addedby_subdealer = Subdealer.objects.get(user=usr)
            new_product.save()
            return JsonResponse(ProductSerializer(new_product, context={'request': request}).data)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)

    else:
        return JsonResponse({'ERR': 'Invalid Http method'}, status=400)


@csrf_exempt
def products_subdealers_product_id_route(request: WSGIRequest, product_id: int) -> JsonResponse:
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)
    usr = auth_result['user']

    if not usr.is_subdealer:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'PUT':
        try:
            request_body = QueryDict(request.body).dict()
            product = Product.objects.get(id=product_id)

            if product.addedby_subdealer != Subdealer.objects.get(user=usr):
                return JsonResponse({'ERR': 'Unauthorized'}, status=401)

            for attr, value in request_body.items():
                if attr == "available_stock":
                    if int(value) < 0:
                        return JsonResponse({'ERR': 'Negative value not allowed.'}, status=400)
                    setattr(product, attr, int(value))
                    if product.available_stock > 0:
                        product.is_available = True
                elif attr == 'is_available':
                    if value == 'true':
                        product.is_available = True
                    else:
                        product.is_available = False

            product.save()
            return JsonResponse(ProductSerializer(product).data)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)

    else:
        return JsonResponse({'ERR': 'HTTP method not allowed.'}, status=403)
