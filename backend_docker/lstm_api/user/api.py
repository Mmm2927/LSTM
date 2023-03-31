from rest_framework import viewsets, permissions, generics, status
from rest_framework.response import Response
from lstm_api.models import User
from .serializers import UserSerializer, LoginSerializer

class UserInfoViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def list(self, request, *args, **kwargs):
        serializer = self.serializer_class(self.queryset, many=True) 
        return Response(serializer.data, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        user_info = generics.get_object_or_404(User, id=kwargs['userid'])
        
        serializer.is_valid(raise_exception = True)

        if not request.user.is_authenticated:
            return Response({'result': 'failed', 'error': 'User not authenticated'}, 
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        serializer = self.serializer_class(user_info)
        return Response(serializer.data)

class UserLoginViewSet(viewsets.ModelViewSet):
    serializer_class = LoginSerializer

    def login(self, request, *args, **kwargs):
        serializer = self.serializer_class(data = request.data)
        serializer.is_valid(raise_exception = True)

        serializer.validate_username(request.data['email'])
        serializer.validate_username(request.data['password'])
