# Generated by Django 3.2.5 on 2021-09-05 15:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0010_alter_session_token'),
    ]

    operations = [
        migrations.AddField(
            model_name='customuser',
            name='is_admin_subdealer',
            field=models.BooleanField(default=False),
        ),
    ]
