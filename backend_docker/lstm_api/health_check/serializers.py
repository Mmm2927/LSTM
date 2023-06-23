from rest_framework import serializers, exceptions
from lstm_api.models import BabyProfile, HealthCheck

class HealthCheckInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthCheck
        #fields = '__all__'
        fields = ('baby', 'check_name', 'mode', 'state', 'date')
