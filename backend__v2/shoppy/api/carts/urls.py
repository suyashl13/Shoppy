from django.urls import path
from .views import cart_route, cart_id_route
from .subdealer.views import subdealer_cart_route, subdealer_cart_id_route

urlpatterns = [
    path('', cart_route),
    path('<int:cart_id>/', cart_id_route),

    # Subdealer Routes
    path('subdealers/', subdealer_cart_route),
    path('subdealers/<int:cart_id>/', subdealer_cart_route),
]
