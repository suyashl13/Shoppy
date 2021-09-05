from django.contrib import admin
from .models import CustomUser, Subdealer, Session

# Register your models here.
model_list = (CustomUser, Subdealer, Session)

for model in model_list:
    admin.site.register(model)
