from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models

class UserManager(BaseUserManager):
    def create_user(self, email, password,name,  **extra_fields):
        if not email:
            raise ValueError('must have user email')
        
        print(**extra_fields)
        user = self.model(
            email = self.normalize_email(email),
            name=name,
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user
    def create_superuser(self, email, password, name, **extra_fields):        
       
        user = self.create_user(            
            email = self.normalize_email(email),            
            password=password,
            name=name,
            **extra_fields
        )        
        user.is_admin = True
        user.is_superuser = True        
        user.is_staff = True
        user.save(using=self._db)        
        return user 

class User(AbstractBaseUser):
    id = models.AutoField(primary_key=True)
    email = models.EmailField(default='', max_length=100, null=False, blank=False, unique=True)
    name = models.CharField(default='', max_length=100, null=False, blank=False)
    phone = models.CharField(default='', max_length=100, null=False, blank=False)

    is_active = models.BooleanField(default=True)    
    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    
    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name', 'phone']

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    def __str__(self):
        return self.email

class BabyProfile(models.Model):
    baby_name = models.TextField(verbose_name="아기이름", blank=True, null=True)
    birth = models.TextField(verbose_name="탄생일", blank=True, null=True)
    gender = models.CharField(verbose_name='성별', default='N', max_length=1)
    user_baby_rel = models.ManyToManyField(User, through='UserBabyRelationship')

    class Meta:
        db_table = 'babyProfile'

class UserBabyRelationship(models.Model):
    user = models.ForeignKey(User, blank=True, null=True, on_delete=models.CASCADE) 
    baby = models.ForeignKey(BabyProfile, blank=True, null=True, on_delete=models.CASCADE)
    #relation = models.CharField(default='N', max_length=1, null=True, blank=True)
    
    relation = models.IntegerField(verbose_name='관계',default=0, blank=True, null=True)
    access_date = models.IntegerField(verbose_name='날짜', blank=True, null=True)

    access_starttime = models.TimeField(verbose_name='시작시간', null=True)
    access_endtime = models.TimeField(verbose_name='종료시간', null=True)

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



