# Generated by Django 3.2.5 on 2021-09-16 10:21

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('carts', '0017_alter_courierdelivery_cart'),
    ]

    operations = [
        migrations.AlterField(
            model_name='courierdelivery',
            name='cart',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to='carts.cart'),
        ),
    ]
