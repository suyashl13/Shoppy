# Generated by Django 3.2.5 on 2021-09-07 08:19

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('carts', '0008_cart_is_canceled'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='cart',
            name='delivered_by',
        ),
        migrations.AddField(
            model_name='cart',
            name='assigned_to',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='assigned_to', to=settings.AUTH_USER_MODEL),
        ),
    ]
