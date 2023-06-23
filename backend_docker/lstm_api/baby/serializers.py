from rest_framework import serializers, exceptions
from django.contrib.auth.models import User
from lstm_api.models import BabyProfile, UserBabyRelationship

class BabyInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = BabyProfile
        fields = ('baby_name', 'birth', 'gender', 'url')

class BabySetSerializer(serializers.ModelSerializer):
    class Meta:
        model = BabyProfile
        fields = ('baby_name', 'birth', 'gender', 'url')

class BabyRearerSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserBabyRelationship
        fields = ('baby', 'relation', 'access_date', 'access_starttime', 'access_endtime', 'active')

    def get_babies(self, validated_data):
        print(validated_data)

class BabyRearerListSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserBabyRelationship
        fields = ('baby', 'user', 'relation', 'access_date', 'access_starttime', 'access_endtime', 'active')

