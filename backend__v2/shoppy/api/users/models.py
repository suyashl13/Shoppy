from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class CustomUser(AbstractUser):
    username = None
    first_name = None
    last_name = None

    name = models.CharField(max_length=38)
    email = models.EmailField(max_length=200, unique=True)
    phone = models.CharField(unique=True, max_length=13)
    address = models.TextField(max_length=255, default="")

    USERNAME_FIELD = 'phone'
    REQUIRED_FIELDS = ['address']

    is_admin_subdealer = models.BooleanField(default=False)
    is_subdealer = models.BooleanField(default=False)
    is_subdealer_staff = models.BooleanField(default=False)
    is_channel_partner = models.BooleanField(default=False)

    pincode = models.CharField(max_length=6)
    is_active = models.BooleanField(default=True)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)

    reporting_to = models.ForeignKey('self', on_delete=models.CASCADE, related_name='c_user', blank=True, null=True)
    ref_by = models.ForeignKey('users.ChannelPartner', on_delete=models.CASCADE, blank=True, null=True)

    def __str__(self):
        return f"{self.name} ({str(self.phone)}) ({str(self.id)})"


class Subdealer(models.Model):
    subdealer_code = models.CharField(max_length=8)
    added_by = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True)

    user = models.OneToOneField(CustomUser, on_delete=models.SET_NULL, default=None, null=True)
    is_active = models.BooleanField(default=True)
    pincodes = models.CharField(max_length=120)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'#{self.id} {self.user.name}'


class Session(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    token = models.CharField(max_length=16)
    device = models.CharField(max_length=60)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)


class ChannelPartner(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.SET_NULL, default=None, null=True)
    ref_code = models.CharField(max_length=8)
    is_active = models.BooleanField(default=False)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)
