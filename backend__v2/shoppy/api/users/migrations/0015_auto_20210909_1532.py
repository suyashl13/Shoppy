# Generated by Django 3.2.5 on 2021-09-09 10:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0014_customuser_is_subdealer_staff'),
    ]

    operations = [
        migrations.RenameField(
            model_name='session',
            old_name='datetime_updated',
            new_name='date_time_created',
        ),
        migrations.RenameField(
            model_name='session',
            old_name='datetime_created',
            new_name='date_time_updated',
        ),
        migrations.AlterField(
            model_name='customuser',
            name='date_time_created',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='customuser',
            name='date_time_updated',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AlterField(
            model_name='subdealer',
            name='date_time_created',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='subdealer',
            name='date_time_updated',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
