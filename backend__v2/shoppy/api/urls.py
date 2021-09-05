from django.urls import path, include
from .views import home

urlpatterns = [
    path('', home),
    path('users/', include('api.users.urls')),
    path('carts/', include('api.carts.urls')),
    path('products/', include('api.products.urls')),
]
