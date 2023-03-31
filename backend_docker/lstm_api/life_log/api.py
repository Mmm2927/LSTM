from .serializers import *
from lstm_api.models import BabyProfile, LifeLog

from rest_framework import status, viewsets, permissions
from rest_framework.response import Response

from django.utils import timezone

class LifeLogInfoViewSet(viewsets.ModelViewSet):
    queryset = LifeLog.objects.all()
    serializer_class = LifeLogInfoSerializer

    def list(self, request, *args, **kwargs):
        serializer = self.serializer_class(self.queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def set(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)

        if not serializer.is_valid():
            return Response({'result': 'failed', 'error': serializer.errors}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if not request.user:
            return Response({'result': 'failed', 'error': 'User not authenticated'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
        obj = serializer.save()
        obj.user = request.user
        obj.date = timezone.now()
        obj.save()
        
        return Response({'result': 'success', 'success_id': obj.id}, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        life_info = LifeLog.objects.get(baby_id=kwargs["babyid"])
        serializer = self.serializer_class(life_info)
        return Response(serializer.data, status=status.HTTP_200_OK)
