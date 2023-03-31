from rest_framework import serializers, exceptions
from django.contrib.auth.models import User
from lstm_api.models import BabyProfile

class BabyInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = BabyProfile
        fields = ('baby_name', 'birth', 'gender')

class BabySetSerializer(serializers.ModelSerializer):
    class Meta:
        model = BabyProfile
        fields = ('baby_name', 'birth', 'gender')

