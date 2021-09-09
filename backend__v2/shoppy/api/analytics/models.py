from django.db import models


# Create your models here.
class Log(models.Model):
    user = models.ForeignKey('users.CustomUser', on_delete=models.SET_NULL, null=True)
    activity_action = models.CharField(max_length=40)

    date_time_created = models.DateTimeField(auto_now_add=True)
    date_time_updated = models.DateTimeField(auto_now=True)
