from django.contrib import admin
from .models import CustomUser, Subdealer, Session, ChannelPartner

# Register your models here.
model_list = (CustomUser, Subdealer, Session, ChannelPartner)

for model in model_list:
    admin.site.register(model)
