from ..models import CustomUser, ChannelPartner
from django.contrib.auth import login
from django.http.response import JsonResponse
from rest_framework import status
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt
from ..serializer import UserSerializers, ChannelPartnerSerializer
from ..helper import perform_login, generate_token
from ...helpers.auth_helper import AuthHelper
from ...carts.models import Cart
from ...carts.serializers import CartSerializer


@csrf_exempt
def channel_partner_route(request: WSGIRequest) -> JsonResponse:
    """
        @route : /users/
        @description : A route to create a new user.
        @type : [ POST ]
        @access : PUBLIC
    """
    if request.method == 'POST':
        # Get required parameters
        try:
            name = request.POST['name']
            email = request.POST['email']
            password = request.POST['password']
            phone = request.POST['phone']
            address = request.POST['address']
            pincode = request.POST['pincode']
        except Exception as e:
            return JsonResponse({'ERR': 'Not Found ' + str(e)}, status=400)

        # Perform Validations
        if len(phone) != 12 and len(phone) != 10:
            return JsonResponse({'ERR': 'Invalid Phone no.'}, status=status.HTTP_400_BAD_REQUEST)
        elif len(password) < 5:
            return JsonResponse({'ERR': 'Weak password.'}, status=status.HTTP_400_BAD_REQUEST)
        elif len(pincode) != 6:
            return JsonResponse({'ERR': 'Invalid Pincode.'}, status=status.HTTP_400_BAD_REQUEST)
        elif str(email).find('@') == -1:
            return JsonResponse({'ERR': 'Invalid email.'}, status=status.HTTP_400_BAD_REQUEST)

        # Create a new user and perform login
        try:
            request_body = request.POST
            new_user = CustomUser()
            new_user.is_active = False
            new_user.is_channel_partner = True

            for key, val in request_body.items():
                if key in ['name', 'email', 'phone', 'address', 'pincode']:
                    setattr(new_user, key, val)
                elif key == 'password':
                    new_user.set_password(raw_password=val)

            new_user.save()

            try:
                cp = ChannelPartner(user=new_user, is_active=False, ref_code=generate_token()[:8].upper())
                cp.save()
            except Exception as e:
                new_user.delete()
                return JsonResponse({'ERR': str(e)}, status=400)

            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                login_response = None
            else:
                login(request, new_user)

            return JsonResponse(
                {'user': UserSerializers(new_user).data, 'jwt': f"{new_user.id}.{login_response['token']}",
                 'channel_partner': ChannelPartnerSerializer(cp).data},
                safe=False)
        except Exception as err:
            return JsonResponse({'ERR': str(err)}, status=status.HTTP_400_BAD_REQUEST)

    if request.method == 'GET':
        # Check authentication
        auth_result = AuthHelper(request=request).check_authentication()
        if auth_result['ERR']:
            return JsonResponse({'ERR': auth_result['MSG']}, status=400)

        usr = auth_result['user']

        if not usr.is_channel_partner:
            return JsonResponse({'ERR': 'Unauthorized'}, statu=401)

        try:
            cp_ref_carts = CartSerializer(Cart.objects.filter(user__ref_by=ChannelPartner.objects.get(user=usr)),
                                          many=True).data
            return JsonResponse(cp_ref_carts, safe=False)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=400)

    return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
