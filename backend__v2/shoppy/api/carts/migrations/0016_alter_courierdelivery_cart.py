# Generated by Django 3.2.5 on 2021-09-16 10:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('carts', '0015_auto_20210916_1230'),
    ]

    operations = [
        migrations.AlterField(
            model_name='courierdelivery',
            name='cart',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to='carts.cart'),
        ),
    ]