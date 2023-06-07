from .serializers import *
from lstm_api.user.serializers import UserSerializer 
from lstm_api.models import User, BabyProfile, UserBabyRelationship

from django.db.models import Q

from rest_framework import status, viewsets, permissions, generics
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

    def modify(self, request, *args, **kwargs):
        baby_info = BabyProfile.objects.get(id=request.data["babyid"])
        
        if "baby_name" in request.data:
            baby_info.update(baby_name = request.data["baby_name"])

        if "gender" in request.data:
            baby_info.update(gender = request.data["gender"])


    def retrieve(self, request, *args, **kwargs):
        baby_info = BabyProfile.objects.get(id=kwargs["babyid"])
        serializer = self.serializer_class(baby_info)
        return Response(serializer.data)

    def delete(self, request, *args, **kwargs):
        relation_info = UserBabyRelationship.objects.filter(baby_id=kwargs["babyid"])
        relation_info.delete()
        baby_info = BabyProfile.objects.get(id=kwargs["babyid"])
        baby_info.delete()

        return Response({'result': 'success'}, status=status.HTTP_200_OK)


class BabyRearer(viewsets.ModelViewSet):
    queryset = UserBabyRelationship.objects.all()
    serializer_class = BabyRearerSerializer

    def list(self, request, *args, **kwargs):
        #queryset = BabyProfile.objects.all()
        serializer = self.serializer_class(self.queryset, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def list_specific(self, request, *args, **kwargs):
        babies_info = UserBabyRelationship.objects.filter(user_id=request.user.id)
        serializer = self.serializer_class(babies_info, many=True)
        return Response(serializer.data)

    def list_rearer(self, request, *args, **kwargs):
        babies_info = UserBabyRelationship.objects.filter(user_id=request.user.id)
        serializer = BabyRearerListSerializer(babies_info, many=True)
        
        print(serializer.data)
        babies_id_list = [x["baby"] for x in serializer.data]
        print(babies_id_list)

        relationship_list = UserBabyRelationship.objects.filter(baby_id__in=babies_id_list)
        serializer_x = BabyRearerListSerializer(relationship_list, many=True)

        print(serializer_x.data)

        return Response("HEHE", status=status.HTTP_200_OK)

    def set(self, request, *args, **kwargs):
        user_info = User.objects.filter(email=request.data['email'])
        
        user_serializer = UserSerializer(user_info, many=True)

        serializer = self.serializer_class(data=request.data)

        #if request.user and serializer.is_valid():
        if not serializer.is_valid():
            return Response({'result': 'failed', 'error': serializer.errors}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if not request.user:
            return Response({'result': 'failed', 'error': 'User not authenticated'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        print(user_serializer.data)

        obj = serializer.save()
        obj.user = request.user
        obj.user_id = user_serializer.data[0]['id']
        obj.active = False
        obj.save()

        return Response({'result': 'success', 'success_id': obj.id}, status=status.HTTP_200_OK)

    def activate(self, request, *args, **kwargs):
        #babies_info = UserBabyRelationship.objects.filter(user_id=request.user.id)
        relation_info = generics.get_object_or_404(
                                    UserBabyRelationship, 
                                    Q(user_id=request.user.id) &
                                    Q(baby_id=request.data['babyid']))
        #serializer = self.serializer_class(relation_info)

        relation_info.active = True
        relation_info.save()

        return Response({'result': 'success'}, status=status.HTTP_200_OK)


    def retrieve(self, request, *args, **kwargs):
        baby_info = BabyProfile.objects.get(id=kwargs["babyid"])
        serializer = self.serializer_class(baby_info)
        return Response(serializer.data)
