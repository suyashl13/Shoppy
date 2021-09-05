from django.urls import path
from .views import produt_route

urlpatterns = [
    path('', produt_route),
]
