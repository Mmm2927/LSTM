from rest_framework import viewsets, permissions, generics, status
from rest_framework.response import Response
from lstm_api.models import User
from .serializers import UserSerializer, UserEditSerializer ,LoginSerializer
from rest_framework.decorators import permission_classes
from rest_framework.permissions import AllowAny

from django.http import JsonResponse

@permission_classes([AllowAny])
class UserInfoViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def list(self, request, *args, **kwargs):
        serializer = self.serializer_class(self.queryset, many=True) 
        return Response(serializer.data, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        user_info = generics.get_object_or_404(User, id=kwargs['userid'])
        
        serializer.is_valid(raise_exception = True)
        serializer = self.serializer_class(user_info)
        return Response(serializer.data)
    
    def retrieve_by_email(self, request, *args, **kwargs):
        try:
            user_info = User.objects.get(email=request.data['email'])
        except:
            return Response("True", status=status.HTTP_200_OK) #legacy
        if user_info is None:
            return Response("True", status=status.HTTP_200_OK)
        else:
            return Response("False", status=status.HTTP_200_OK)

class UserModifyViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def remove(self, request, *args, **kwargs):
        user_info = generics.get_object_or_404(User, id=request.user.id)
        user_info.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

    def edit(self, request, *args, **kwargs):
        serializer = UserEditSerializer(request.data, instance=request.user)
        
        if serializer.is_valid():
            serializer.save()
            return Response("True", status=status.HTTP_200_OK)
        else:
            return Response("Nope", status=status.HTTP_200_OK)
        return Response("False", status=status.HTTP_200_OK)


class UserLoginViewSet(viewsets.ModelViewSet):
    serializer_class = LoginSerializer

    def login(self, request, *args, **kwargs):
        serializer = self.serializer_class(data = request.data)
        serializer.is_valid(raise_exception = True)

        serializer.validate_username(request.data['email'])
        serializer.validate_username(request.data['password'])

    def remove(self, request, *args, **kwargs):
        user_info = generics.get_object_or_404(User, id=request.user.id)
        user_info.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
