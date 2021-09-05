# Generated by Django 3.2.5 on 2021-08-14 09:59

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('products', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Cart',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('is_delivered', models.BooleanField(default=False)),
                ('is_verified', models.BooleanField(default=False)),
                ('date_time_created', models.DateTimeField(auto_now=True)),
                ('date_time_updated', models.DateTimeField(auto_now_add=True)),
                ('payment_method', models.CharField(max_length=12)),
                ('subtotal', models.FloatField()),
                ('order_status', models.CharField(max_length=15)),
                ('discount_price', models.FloatField()),
                ('tax_amount', models.FloatField()),
                ('shipping_address', models.CharField(max_length=150)),
                ('pin_code', models.CharField(max_length=8)),
                ('phone', models.CharField(max_length=8)),
                ('delivered_by', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='delivered_by', to=settings.AUTH_USER_MODEL)),
                ('user', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='CourierDelivery',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('courier_name', models.CharField(max_length=50)),
                ('courier_tracking_id', models.CharField(max_length=50)),
                ('cart', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='carts.cart')),
            ],
        ),
        migrations.CreateModel(
            name='CartItem',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.IntegerField()),
                ('amount', models.FloatField()),
                ('date_time_created', models.DateTimeField(auto_now=True)),
                ('date_time_updated', models.DateTimeField(auto_now_add=True)),
                ('cart', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='carts.cart')),
                ('product', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='products.product')),
            ],
        ),
    ]
