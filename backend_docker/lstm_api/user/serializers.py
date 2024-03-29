from rest_framework import serializers
from lstm_api.models import User as UserProfile

from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserChangeForm, ReadOnlyPasswordHashField

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['id', 'name', 'email', 'phone', 'password']

class UserEditSerializer(UserChangeForm):
    password = ReadOnlyPasswordHashField()

    class Meta:
        model = UserProfile
        fields = ['name', 'phone', 'password']

    def clean_password(self):
        return self.initial["password"]

class LoginSerializer(serializers.ModelSerializer):
    username = serializers.CharField()
    password = serializers.CharField()

    class Meta:
        model = User
        fields = ['email', 'password', 'name', 'phone']

    def validate_username(self, username):
        if not username:
            raise exceptions.ValidationError(('아이디를 입력해주세요.'))
        return username

    def validate_password(self, password):
        if not password:
            raise exceptions.ValidationError(('패스워드를 입력해주세요.'))
        return password

    def validate(self, attrs):
        user = authenticate(**attrs)
        if user and user.is_active:
            return user

        raise serializers.ValidationError(("이메일 혹은 패스워드를 확인해주세요."))
