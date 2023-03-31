from rest_framework import serializers, exceptions
from lstm_api.models import BabyProfile, GrowthLog 

class GrowthLogInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = GrowthLog
        #fields = '__all__'
        fields = ('baby', 'height', 'weight', 'date')
