from django.http import JsonResponse, QueryDict
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


@csrf_exempt
def superuser_product_id_route(request: WSGIRequest, product_id: int):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    try:
        product = Product.objects.get(id=product_id)
    except Exception as e:
        return JsonResponse({'ERR': str(e)}, status=400)

    if request.method == 'PUT':
        request_body = QueryDict(request.body).dict()

        for key, val in request_body.items():
            if key == 'is_active':
                setattr(product, key, True) if val == 'true' else setattr(product, key, False)
            else:
                setattr(product, key, val)

        try:
            product.save()
            product_dict = ProductSerializer(product, context={'request': request}).data
            if product.addedby_subdealer is not None:
                try:
                    product_dict['addedby_subdealer'] = SubdealerSerializer(product.addedby_subdealer).data
                    product_dict['addedby_subdealer']['user'] = UserSerializers(product.addedby_subdealer.user).data
                except Exception as e:
                    print(e)
                    product_dict['addedby_subdealer'] = None

            if product.category is not None:
                product_dict['category'] = product.category.name

            return JsonResponse(product_dict)
        except Exception as e:
            return JsonResponse({'ERR': 'Unable to edit product'}, status=400)


@csrf_exempt
def category_superuser_id_route(request: WSGIRequest, category_id: int):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    try:
        category = Category.objects.get(id=category_id)
    except Exception as e:
        return JsonResponse({'ERR': str(e)}, status=400)

    if request.method == 'PUT':
        request_body = QueryDict(request.body).dict()

        for key, val in request_body.items():
            if key == 'is_active':
                setattr(category, key, True) if val == 'true' else setattr(category, key, False)
            else:
                setattr(category, key, val)

        try:
            category.save()
            return JsonResponse(CategorySerializer(category, context={'request': request}).data)
        except Exception as e:
            return JsonResponse({'ERR': 'Unable tu update category.'}, status=400)
