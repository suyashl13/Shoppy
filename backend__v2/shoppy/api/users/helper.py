import random
import string
from .models import CustomUser, Session
from .serializer import SessionSerializer


def generate_token() -> str:
    return ''.join(random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits) for i in range(16))


def get_absolute_boolean(stringy_boolean: str) -> bool:
    if stringy_boolean == 'true' or stringy_boolean == 'True':
        return True
    else:
        return False


def perform_login(phone: str, password: str, device='NO_DEVICE_FOUND'):
    try:
        user = CustomUser.objects.get(phone=phone)
    except Exception as e:
        print(e)
        return False

    if user.check_password(password):
        session = Session(user=user, token=generate_token(), device=device)
        session.save()
        return SessionSerializer(session).data
    else:
        return False
