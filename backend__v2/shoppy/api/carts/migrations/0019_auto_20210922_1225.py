# Generated by Django 3.2.5 on 2021-09-22 06:55

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('carts', '0018_alter_courierdelivery_cart'),
    ]

    operations = [
        migrations.AddField(
            model_name='courierdelivery',
            name='date_time_created',
            field=models.DateTimeField(auto_now_add=True, default=django.utils.timezone.now),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='courierdelivery',
            name='date_time_updated',
            field=models.DateTimeField(auto_now=True),
        ),
    ]