# Generated by Django 3.2.5 on 2021-09-26 04:16

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0017_channelpartner_is_active'),
    ]

    operations = [
        migrations.AlterField(
            model_name='channelpartner',
            name='user',
            field=models.OneToOneField(default=None, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='subdealer',
            name='user',
            field=models.OneToOneField(default=None, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
    ]