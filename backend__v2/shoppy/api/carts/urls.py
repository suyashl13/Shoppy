from django.urls import path
from .views import cart_route, cart_id_route
from .subdealer.views import subdealer_cart_route, subdealer_cart_id_route, subdealer_courier_cart_id_route
from .staff.views import staff_cart_route, staff_cart_id_route
from .superuser.views import superuser_route

urlpatterns = [
    path('', cart_route),
    path('<int:cart_id>/', cart_id_route),

    # Subdealer Routes
    path('subdealers/', subdealer_cart_route),
    path('subdealers/<int:cart_id>/', subdealer_cart_id_route),
    path('subdealers/courier_delivery/<int:cart_id>/', subdealer_courier_cart_id_route),

    # Staff Routes
    path('staff/', staff_cart_route),
    path('staff/<int:cart_id>/', staff_cart_id_route),

    # Superuser
    path('superuser/', superuser_route),
]
