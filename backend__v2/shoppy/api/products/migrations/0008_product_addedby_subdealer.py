# Generated by Django 3.2.5 on 2021-09-13 08:07

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0015_auto_20210909_1532'),
        ('products', '0007_alter_product_description'),
    ]

    operations = [
        migrations.AddField(
            model_name='product',
            name='addedby_subdealer',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.SET_NULL, to='users.subdealer'),
        ),
    ]
