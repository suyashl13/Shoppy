from ..models import CustomUser, Subdealer
from django.contrib.auth import login
from django.http.response import JsonResponse
from rest_framework import status
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt
from ..serializer import UserSerializers
from ..helper import perform_login, get_absolute_boolean


@csrf_exempt
def staff_route(request: WSGIRequest) -> JsonResponse:
    """
        @route : /users/
        @description : A route to create a new user.
        @type : [ POST ]
        @access : PUBLIC
    """
    if request.method == 'POST':
        print("STAFF USR")
        # Get required parameters
        try:
            name = request.POST['name']
            email = request.POST['email']
            password = request.POST['password']
            phone = request.POST['phone']
            address = request.POST['address']
            pincode = request.POST['pincode']

            subdealer_code = request.POST['subdealer_code']
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
            new_user = CustomUser()
            new_user.is_subdealer = False
            new_user.is_active = False
            new_user.is_subdealer_staff = True

            for attribute, value in request.POST.dict().items():
                if attribute == 'password':
                    new_user.set_password(raw_password=value)
                elif attribute == 'is_superuser':
                    if value == 'true':
                        return JsonResponse({'ERR': 'Unauthorized'}, status=401)
                elif attribute != 'subdealer_code':
                    setattr(new_user, attribute, value)

            try:
                master_subdealer = Subdealer.objects.get(subdealer_code=subdealer_code)
                if not master_subdealer.is_active:
                    return JsonResponse({'ERR': 'subdealer is deactivated'}, status=400)
                new_user.reporting_to = master_subdealer.user
            except Exception as err:
                return JsonResponse({'ERR': str(err)}, status=status.HTTP_400_BAD_REQUEST)

            new_user.save()

            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                login_response = None
            else:
                login(request, new_user)

            return JsonResponse(
                {'user': UserSerializers(new_user).data, 'jwt': f"{new_user.id}.{login_response['token']}"},
                safe=False)
        except Exception as err:
            return JsonResponse({'ERR': str(err)}, status=status.HTTP_400_BAD_REQUEST)
    return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
