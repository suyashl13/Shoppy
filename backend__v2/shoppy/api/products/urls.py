from django.urls import path
from .views import product_route
from .subdealer.views import products_subdealers_route, products_subdealers_product_id_route
from .superuser.views import superuser_product_route

urlpatterns = [
    path('', product_route),

    # Subdealer Routes
    path('subdealers/', products_subdealers_route),
    path('subdealers/<int:product_id>/', products_subdealers_product_id_route),

    # Superuser Routes
    path('superuser/', superuser_product_route)
]
