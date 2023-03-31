from django.urls import path, include

from lstm_api.account import api as account_api
from lstm_api.baby import api as baby_api
from lstm_api.life_log import api as lifelog_api
from lstm_api.growth_log import api as growthlog_api
from lstm_api.health_check import api as health_check_api

urlpatterns = [
        path('user/login/', account_api.CustomLoginView.as_view()),
        path('user/', include('dj_rest_auth.urls')),
        path('user/registration/', include('dj_rest_auth.registration.urls')),

        path('baby/list', baby_api.BabyInfoViewSet.as_view({'get': 'list'})),
        path('baby/set', baby_api.BabyInfoViewSet.as_view({'post': 'set'})),
        path('baby/<int:babyid>/get', baby_api.BabyInfoViewSet.as_view({'post': 'retrieve'})),

        path('life/list', lifelog_api.LifeLogInfoViewSet.as_view({'get': 'list'})),
        path('life/set', lifelog_api.LifeLogInfoViewSet.as_view({'post': 'set'})),
        path('life/<int:babyid>/get', lifelog_api.LifeLogInfoViewSet.as_view({'post': 'retrieve'})),

        path('growth/list', growthlog_api.GrowthLogInfoViewSet.as_view({'get': 'list'})),
        path('growth/set', growthlog_api.GrowthLogInfoViewSet.as_view({'post': 'set'})),
        path('growth/<int:babyid>/get', growthlog_api.GrowthLogInfoViewSet.as_view({'post': 'retrieve'})),

        path('health/list', health_check_api.HealthCheckInfoViewSet.as_view({'get': 'list'})),
        path('health/set', health_check_api.HealthCheckInfoViewSet.as_view({'post': 'set'})),
        path('health/<int:babyid>/get', health_check_api.HealthCheckInfoViewSet.as_view({'post': 'retrieve'})),
    ]
