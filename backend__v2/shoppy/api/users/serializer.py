from .models import CustomUser, Session, Subdealer, ChannelPartner
from rest_framework.serializers import ModelSerializer


class UserSerializers(ModelSerializer):
    def create(self, validated_data):
        password = validated_data.pop('password', None)
        super_user_status = validated_data.pop('is_superuser', None)
        instance = self.Meta.model(**validated_data)

        if super_user_status:
            instance.is_superuser = False
        instance.save()

        if password is not None:
            instance.set_password(raw_password=password)
        instance.save()

        return instance

    def update(self, instance, validated_data):
        for attr, value in validated_data.items():
            if attr == 'password':
                instance.set_password(raw_password=value)
            else:
                setattr(instance, attr, value)
        instance.save()
        return instance

    class Meta:
        model = CustomUser
        extra_kwargs = {'password': {'write_only': True}}
        fields = (
            'id', 'name', 'email', 'password',
            'is_active', 'phone', 'is_staff', 'pincode', 'address', 'is_subdealer', 'is_admin_subdealer',
            'date_time_created', 'date_time_updated')


class SessionSerializer(ModelSerializer):
    class Meta:
        model = Session
        fields = '__all__'


class SubdealerSerializer(ModelSerializer):
    class Meta:
        model = Subdealer
        fields = '__all__'


class ChannelPartnerSerializer(ModelSerializer):
    class Meta:
        model = ChannelPartner
        fields = '__all__'
