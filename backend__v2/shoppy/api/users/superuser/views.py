from django.http.response import JsonResponse
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt

from .helper import get_subdealer_carts
from ..models import CustomUser, Subdealer
from ...products.models import Product
from ...products.serializers import ProductSerializer
from ..serializer import UserSerializers, SubdealerSerializer
from api.helpers.auth_helper import AuthHelper
from django.http import QueryDict


@csrf_exempt
def superuser_route(request: WSGIRequest):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        return JsonResponse(UserSerializers(usr).data)


@csrf_exempt
def superuser_subdealer_route(request: WSGIRequest):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'GET':
        all_subdealers = Subdealer.objects.all()
        all_subdealers = SubdealerSerializer(all_subdealers, many=True).data
        res = []
        for subdealer in all_subdealers:
            try:
                subdealer['user'] = UserSerializers(CustomUser.objects.get(id=subdealer['user'])).data
                subdealer['products'] = ProductSerializer(Product.objects.filter(addedby_subdealer__id=subdealer['id']),
                                                          many=True, context={'request': request}).data
                subdealer['carts'] = get_subdealer_carts(subdealer['pincodes'], request)
                subdealer['staff'] = UserSerializers(
                    CustomUser.objects.filter(reporting_to__id=subdealer['user']['id']), many=True).data
                res.append(subdealer)
            except Exception as e:
                pass

        return JsonResponse(all_subdealers, safe=False)


@csrf_exempt
def superuser_subdealer_id_route(request: WSGIRequest, subdealer_id: int):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse(dict(ERR=auth_result['MSG']), status=400)

    usr = auth_result['user']
    try:
        subdealer = Subdealer.objects.get(id=subdealer_id)
    except Exception:
        return JsonResponse({'ERR': 'Invalid subdealer Id.'}, status=400)

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    if request.method == 'PUT':
        request_body = QueryDict(request.body).dict()

        for key, val in request_body.items():
            if key == 'is_active':
                setattr(subdealer, key, True) if val == 'true' else setattr(subdealer, key, False)
            else:
                setattr(subdealer, key, val)

        try:
            subdealer.save()
            subdealer = SubdealerSerializer(subdealer).data

            # Get Additional information
            subdealer['user'] = UserSerializers(CustomUser.objects.get(id=subdealer['user'])).data
            subdealer['products'] = ProductSerializer(Product.objects.filter(addedby_subdealer__id=subdealer['id']),
                                                      many=True, context={'request': request}).data
            subdealer['carts'] = get_subdealer_carts(subdealer['pincodes'], request)
            subdealer['staff'] = UserSerializers(CustomUser.objects.filter(reporting_to__id=subdealer['user']['id']),
                                                 many=True).data
            return JsonResponse(subdealer)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)


@csrf_exempt
def superuser_subdealer_staff_route(request: WSGIRequest):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse(dict(ERR=auth_result['MSG']), status=400)

    usr = auth_result['user']

    if request.method == 'GET':
        all_staff = UserSerializers(CustomUser.objects.filter(is_subdealer_staff=True), many=True).data
        res = []
        for staff in all_staff:
            staff['reporting_to'] = UserSerializers(CustomUser.objects.get(id=staff['reporting_to'])).data
            res.append(staff)

        return JsonResponse(res, safe=False)


@csrf_exempt
def superuser_subdealer_staff_id_route(request: WSGIRequest, staff_id: int):
    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse(dict(ERR=auth_result['MSG']), status=400)

    usr = auth_result['user']

    # Check Role
    if not usr.is_superuser:
        return JsonResponse({'ERR': 'Unauthorized'}, status=401)

    try:
        staff_user = CustomUser.objects.get(id=staff_id)
        if not staff_user.is_subdealer_staff:
            return JsonResponse({'ERR': 'Invalid staff id.'}, status=400)
    except Exception as e:
        return JsonResponse({"ERR": str(e)}, status=400)

    if request.method == 'PUT':
        request_body = QueryDict(request.body).dict()

        for (key, val) in request_body.items():
            if key == 'is_active':
                setattr(staff_user, key, True) if val == 'true' else setattr(staff_user, key, False)
            else:
                setattr(staff_user, key, val)

        try:
            staff_user.save()

            staff_user = UserSerializers(staff_user).data
            staff_user['reporting_to'] = UserSerializers(CustomUser.objects.get(id=staff_user['reporting_to'])).data
            return JsonResponse(staff_user)
        except Exception as e:
            return JsonResponse({"ERR": str(e)}, status=400)
