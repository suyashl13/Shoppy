from django.urls import path
from .views import user_route, login_route, logout_route, check_user, check_session, user_id_route
from .subdealer.views import subdealer_id_route, subdealer_login_route, subdealer_route, subdealer_staff_id_route
from .staff.views import staff_route
from .channel_partner.views import channel_partner_route, channel_partner_login_route
from .superuser.views import superuser_route, superuser_subdealer_route, superuser_subdealer_id_route, \
    superuser_subdealer_staff_route, superuser_subdealer_staff_id_route

urlpatterns = [
    path('', user_route),
    path('login/', login_route),
    path('logout/', logout_route),
    path('<int:u_id>/', user_id_route),
    path('check_user/<int:phone_number>/', check_user),
    path('check_session/<int:phone_number>/', check_session),

    # Subdealer
    path('subdealers/', subdealer_route),
    path('subdealers/login/', subdealer_login_route),
    path('subdealers/<int:u_id>/', subdealer_id_route),
    path('subdealers/staff/<int:staff_id>/', subdealer_staff_id_route),

    # Staff
    path('staff/', staff_route),

    # Channel Partner
    path('channel_partners/', channel_partner_route),
    path('channel_partners/login/', channel_partner_login_route),

    # Superuser
    path('superuser/', superuser_route),
    path('superuser/subdealers/', superuser_subdealer_route),
    path('superuser/subdealers/<int:subdealer_id>/', superuser_subdealer_id_route),
    path('superuser/subdealer_staff/', superuser_subdealer_staff_route),
    path('superuser/subdealer_staff/<int:staff_id>/', superuser_subdealer_staff_id_route),
]
