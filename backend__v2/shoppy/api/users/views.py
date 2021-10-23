from .models import CustomUser, Session, Subdealer, ChannelPartner
from django.contrib.auth import login, logout
from django.http.response import JsonResponse
from rest_framework import status
from django.http import QueryDict
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt
from .serializer import UserSerializers, SubdealerSerializer
from .helper import perform_login, get_absolute_boolean
from ..helpers.auth_helper import AuthHelper


@csrf_exempt
def user_route(request: WSGIRequest) -> JsonResponse:
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
            ref_code = request.POST['ref_code']
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
        if ref_code == '':
            ref_code = None

        # Create a new user and perform login
        try:
            new_user = CustomUser()
            for attribute, value in request.POST.dict().items():
                if attribute == 'password':
                    new_user.set_password(raw_password=value)
                elif attribute == 'is_subdealer':
                    if value == 'true':
                        return JsonResponse({'ERR': 'Unauthorized'}, status=401)
                elif attribute == 'is_superuser':
                    if value == 'true':
                        return JsonResponse({'ERR': 'Unauthorized'}, status=401)
                elif attribute == 'ref_code':
                    # register with channel partner.
                    if ref_code is not None:
                        try:
                            cp = ChannelPartner.objects.get(ref_code=ref_code)
                            new_user.ref_by = cp
                        except Exception:
                            return JsonResponse(
                                {'ERR': "Invalid reference code. If you don't have any please leave it blank."},
                                status=400)
                else:
                    setattr(new_user, attribute, value)

            new_user.save()
            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                login_response = None
            else:
                login(request, new_user)

            return JsonResponse(
                {'user': UserSerializers(new_user).data, 'jwt': f"{new_user.id}.{login_response['token']}"}, safe=False)
        except Exception as err:
            return JsonResponse({'ERR': str(err)}, status=status.HTTP_400_BAD_REQUEST)
    return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@csrf_exempt
def user_id_route(request: WSGIRequest, u_id: int) -> JsonResponse:
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
            return JsonResponse(UserSerializers(usr).data)
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
def login_route(request: WSGIRequest) -> JsonResponse:
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
            if usr.is_subdealer or usr.is_admin_subdealer:
                return JsonResponse({'ERR': 'Invalid login route'}, status=status.HTTP_401_UNAUTHORIZED)

            # Perform user login
            login_response = perform_login(phone, password, request.META['HTTP_USER_AGENT'])
            if login_response is False:
                return JsonResponse({'ERR': 'Unable to login.'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                if usr.is_subdealer:
                    try:
                        subdealer_details = Subdealer.objects.get()
                        subdealer_details = SubdealerSerializer(subdealer_details).data
                    except:
                        subdealer_details = None
                    return JsonResponse(
                        {'user': UserSerializers(usr).data, 'jwt': f"{usr.id}.{login_response['token']}",
                         'subdealer': subdealer_details},
                        safe=False)
                else:
                    return JsonResponse(
                        {'user': UserSerializers(usr).data, 'jwt': f"{usr.id}.{login_response['token']}"},
                        safe=False)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    else:
        return JsonResponse({'ERR': 'Invalid HTTP method.'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@csrf_exempt
def logout_route(request: WSGIRequest):
    """
        @route : /users/logout/
        @description : A route to logout a user.
        @type : [ GET ]
        @access : PRIVATE
    """
    if request.method == 'GET':
        try:
            jwt = str(request.headers['Authorization'])
            session = Session.objects.get(token=jwt.split('.')[1])
            session_usr = CustomUser.objects.get(id=int(jwt.split('.')[0]))
            if session.user == session_usr:
                session.delete()
                logout(request)
                return JsonResponse({'INFO': 'Successfully logged out.'}, status=200)
            else:
                return JsonResponse({'ERR': 'Invalid jwt token.'}, status=401)
        except Exception as e:
            return JsonResponse({'ERR': str(e)}, status=500)


@csrf_exempt
def check_user(request, phone_number):
    """
        @route : /users/check_user/<str:phone_number>/
        @description : A route to check user existence.
        @type : [ GET ]
        @access : PUBLIC
    """
    if request.method != "GET":
        return JsonResponse({"ERR": "Only GET request allowed"}, status=400)

    try:
        CustomUser.objects.get(phone=phone_number)
        return JsonResponse({'exists': True})
    except:
        return JsonResponse({'exists': False})


@csrf_exempt
def check_session(request: WSGIRequest, phone_number):
    """
        @route : /users
        @description : A route to check user session.
        @type : [ GET ]
        @access : PRIVATE
    """
    if request.method != "GET":
        return JsonResponse({"ERR": "Only GET request allowed"}, status=400)

    try:
        session_token = str(request.headers['Authorization']).split('.')[1]

        usr = CustomUser.objects.get(phone=phone_number)
        session = Session.objects.get(token=session_token)

        if session.user == usr:
            return JsonResponse({'exists': True})
        else:
            return JsonResponse({'exists': False})

    except Exception as e:
        return JsonResponse({'exists': False}, status=200)
