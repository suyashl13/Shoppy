# Generated by Django 3.2.5 on 2021-09-06 07:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0013_alter_customuser_is_staff'),
    ]

    operations = [
        migrations.AddField(
            model_name='customuser',
            name='is_subdealer_staff',
            field=models.BooleanField(default=False),
        ),
    ]
