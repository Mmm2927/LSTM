from .serializers import *
from lstm_api.models import User, BabyProfile, UserBabyRelationship

from rest_framework import status, viewsets, permissions
from rest_framework.response import Response

class BabyInfoViewSet(viewsets.ModelViewSet):
    queryset = BabyProfile.objects.all()
    serializer_class = BabyInfoSerializer

    def list(self, request, *args, **kwargs):
        #queryset = BabyProfile.objects.all()
        serializer = self.serializer_class(self.queryset, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def set(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)

        #if request.user and serializer.is_valid():
        if not serializer.is_valid():
            return Response({'result': 'failed', 'error': serializer.errors}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if not request.user:
            return Response({'result': 'failed', 'error': 'User not authenticated'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
        obj = serializer.save()
        obj.user = request.user
        obj.user_baby_rel.set([request.user])
        obj.save()
        
        return Response({'result': 'success', 'success_id': obj.id}, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        baby_info = BabyProfile.objects.get(id=kwargs["babyid"])
        serializer = self.serializer_class(baby_info)
        return Response(serializer.data)

class BabyRearer(viewsets.ModelViewSet):
    queryset = UserBabyRelationship.objects.all()
    serializer_class = BabyInfoSerializer

    def list(self, request, *args, **kwargs):
        #queryset = BabyProfile.objects.all()
        serializer = self.serializer_class(self.queryset, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def set(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)

        #if request.user and serializer.is_valid():
        if not serializer.is_valid():
            return Response({'result': 'failed', 'error': serializer.errors}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if not request.user:
            return Response({'result': 'failed', 'error': 'User not authenticated'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        obj = serializer.save()
        obj.user = request.user
        obj.user_baby_rel.set([request.user])
        obj.save()

        return Response({'result': 'success', 'success_id': obj.id}, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        baby_info = BabyProfile.objects.get(id=kwargs["babyid"])
        serializer = self.serializer_class(baby_info)
        return Response(serializer.data)
