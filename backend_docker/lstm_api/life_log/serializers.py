from rest_framework import serializers, exceptions
from lstm_api.models import BabyProfile, LifeLog 

class LifeLogInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = LifeLog
        #fields = '__all__'
        fields = ('date', 'mode', 'content')
