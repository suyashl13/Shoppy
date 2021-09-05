from ..models import CustomUser, Session, Subdealer
from django.contrib.auth import login, logout
from django.http.response import JsonResponse
from rest_framework import status
from django.http import QueryDict
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt
from ..serializer import UserSerializers, SubdealerSerializer
from ..helper import perform_login, get_absolute_boolean, generate_token
from ...helpers.auth_helper import AuthHelper


@csrf_exempt
def subdealer_route(request: WSGIRequest) -> JsonResponse:
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
            is_subdealer = get_absolute_boolean(request.POST['is_subdealer'])
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
            for attribute, value in request.POST.dict().items():
                if attribute == 'password':
                    new_user.set_password(raw_password=value)
                elif attribute == 'is_subdealer':
                    if value == 'false':
                        return JsonResponse({'ERR': 'Unauthorized'}, status=401)
                    else:
                        new_user.is_subdealer = True
                elif attribute == 'is_superuser':
                    if value == 'true':
                        return JsonResponse({'ERR': 'Unauthorized'}, status=401)
                else:
                    setattr(new_user, attribute, value)

            new_subdealer = Subdealer()

            if new_user.is_subdealer:
                new_subdealer.user = new_user
                new_subdealer.subdealer_code = generate_token()[0:8].upper()
                new_subdealer.pincodes = ''
                try:
                    if request.POST.dict()['ref_code'] is not None:
                        try:
                            new_subdealer.added_by = Subdealer.objects.get(subdealer_code=request.POST['ref_code'])
                        except Exception as e:
                            print(type(e))
                            return JsonResponse({'ERR': 'Invalid refrence code.'}, status=400)
                except:
                    new_subdealer.added_by = None

                new_user.save()
                new_subdealer.save()

            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                login_response = None
            else:
                login(request, new_user)

            return JsonResponse(
                {'user': UserSerializers(new_user).data, 'jwt': f"{new_user.id}.{login_response['token']}",
                 'subdealer': SubdealerSerializer(new_subdealer).data
                 }, safe=False)
        except Exception as err:
            return JsonResponse({'ERR': str(err)}, status=status.HTTP_400_BAD_REQUEST)
    return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@csrf_exempt
def subdealer_id_route(request: WSGIRequest, u_id: int) -> JsonResponse:
    """
            @route : /users/<int:id>/
            @description : A route to GET the user info.
            @type : [ GET ]
            @access : PRIVATE
    """

    auth_result = AuthHelper(request=request).check_authentication()
    if auth_result['ERR']:
        return JsonResponse({'ERR': auth_result['MSG']}, status=400)

    usr = auth_result['user']

    if request.method == 'GET':
        if usr.id == u_id:
            subdealer_profile = SubdealerSerializer(Subdealer.objects.get(user=usr)).data
            return JsonResponse({
                'user': UserSerializers(usr).data,
                'subdealer': subdealer_profile})
        else:
            return JsonResponse({'ERR': 'Unauthorized'})

    elif request.method == 'PUT':
        try:
            request_body = QueryDict(request.body).dict()
            for param, value in request_body.items():
                if param in ['name', 'email', 'password', 'phone', 'address', 'pincode']:
                    setattr(usr, param, value)
            usr.save()
            return JsonResponse(UserSerializers(usr).data)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=status.HTTP_401_UNAUTHORIZED)
    else:
        return JsonResponse({'ERR': "Method not allowed"}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@csrf_exempt
def subdealer_login_route(request: WSGIRequest) -> JsonResponse:
    """
        @route : /users/login/
        @description : A route to login the user into app.
        @type : [ POST ]
        @access : PUBLIC
    """

    if request.method == 'POST':
        # Get required parameters
        try:
            phone = request.POST['phone']
            password = request.POST['password']
        except Exception as e:
            return JsonResponse({'ERR': 'Not Found ' + str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Check role
        try:
            usr = CustomUser.objects.get(phone=phone)
            if not usr.is_subdealer:
                return JsonResponse({'ERR': 'Invalid login route'}, status=status.HTTP_401_UNAUTHORIZED)

            # Perform user login
            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                return JsonResponse({'ERR': 'Unable to login.'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                try:
                    subdealer_details = Subdealer.objects.get()
                    subdealer_details = SubdealerSerializer(subdealer_details).data
                except:
                    subdealer_details = None
                return JsonResponse(
                    {'user': UserSerializers(usr).data, 'jwt': f"{usr.id}.{login_response['token']}",
                     'subdealer': subdealer_details},
                    safe=False)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    else:
        return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
