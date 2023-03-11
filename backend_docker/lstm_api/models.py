from django.contrib.auth.models import User
from django.db import models

class UserProfile(models.Model):
    user = models.OneToOneField(User, blank=True, null=True, on_delete=models.SET_NULL)
    user_name = models.TextField(verbose_name="사용자이름", blank=True, null=True)
    password = models.TextField(verbose_name="비밀번호", blank=True, null=True)
    email = models.TextField(verbose_name='이메일', blank=True, null=True)
    profile_img = models.FilePathField(verbose_name='사용자이미지', blank=True, null=True)
    relation = models.CharField(verbose_name='관계', default='N', max_length=1)

    class Meta:
        db_table = 'userProfile'

class BabyProfile(models.Model):
    baby_name = models.TextField(verbose_name="아기이름", blank=True, null=True)
    birth = models.DateField(auto_now=True)
    gender = models.CharField(verbose_name='성별', default='N', max_length=1)
    user_baby_rel = models.ManyToManyField(UserProfile, through='UserBabyRelationship')

    class Meta:
        db_table = 'babyProfile'

class UserBabyRelationship(models.Model):
    user = models.ForeignKey(UserProfile, blank=True, null=True, on_delete=models.CASCADE) 
    baby = models.ForeignKey(BabyProfile, blank=True, null=True, on_delete=models.CASCADE)

    class Meta:
        db_table = 'userBabyRelationship'
        unique_together = ('user', 'baby')

class LifeLog(models.Model):
    baby = models.ForeignKey(BabyProfile, blank=True, null=True, on_delete=models.CASCADE)
    date = models.DateField(auto_now=True)
    mode = models.CharField(verbose_name='행위', default='N', max_length=1)
    content = models.TextField(verbose_name="기록내용", blank=True, null=True)

    class Meta:
        db_table = 'lifeLog'

class GrowthLog(models.Model):
    baby = models.ForeignKey(BabyProfile, blank=True, null=True, on_delete=models.CASCADE)
    height = models.IntegerField(verbose_name='키', blank=True, null=True)
    weight = models.IntegerField(verbose_name='몸무게', blank=True, null=True)
    date = models.DateField(verbose_name='날짜', auto_now=True)

    class Meta:
        db_table = 'growthLog'

class HealthCheck(models.Model):
    baby = models.ForeignKey(BabyProfile, blank=True, null=True, on_delete=models.CASCADE)
    check_name = models.TextField(verbose_name="접종/검진 이력", blank=True, null=True)
    mode = models.CharField(verbose_name='예방접종/건강검진', default='N', max_length=1)
    state = models.CharField(verbose_name='수행여부', default='N', max_length=1)

    class Meta:
        db_table = 'healthCheck'



