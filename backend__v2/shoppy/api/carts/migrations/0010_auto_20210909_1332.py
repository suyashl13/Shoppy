# Generated by Django 3.2.5 on 2021-09-09 08:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('carts', '0009_auto_20210907_1349'),
    ]

    operations = [
        migrations.AlterField(
            model_name='cart',
            name='date_time_created',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='cart',
            name='date_time_updated',
            field=models.DateTimeField(auto_now=True),
        ),
    ]