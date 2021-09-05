from django.core.handlers.wsgi import WSGIRequest
from ..users.models import CustomUser, Session


class AuthHelper:
    def __init__(self, request: WSGIRequest):
        self.request = request

    def check_authentication(self) -> dict:
        try:
            user_id, session_token = str(self.request.headers['Authorization']).split('.')[0], \
                                     str(self.request.headers['Authorization']).split('.')[1]
        except Exception as e:
            return {'ERR': True, 'MSG': 'Invalid authorization header.'}

        try:
            usr = CustomUser.objects.get(id=user_id)
            session = Session.objects.get(token=session_token)
            return {'ERR': False, 'MSG': None, 'user': usr, 'session': session}
        except Exception as e:
            return {'ERR': True, 'MSG': str(e)}
