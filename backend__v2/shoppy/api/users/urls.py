from django.urls import path
from .views import user_route, login_route, logout_route, check_user, check_session, user_id_route
from .subdealer.views import subdealer_id_route, subdealer_login_route, subdealer_route, subdealer_staff_id_route
from .staff.views import staff_route


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
    path('staff/', staff_route)
]
