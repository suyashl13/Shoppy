# Generated by Django 3.2.5 on 2021-09-16 06:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('carts', '0012_auto_20210916_1222'),
    ]

    operations = [
        migrations.AddField(
            model_name='courierdelivery',
            name='ref_phone',
            field=models.CharField(default='', max_length=12),
        ),
    ]
