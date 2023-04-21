import 'package:get/get.dart';

class Languages extends Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
    'ko_KR':{
      'main4_manageBaby' : '아이 관리',
      'main4_addBaby' : '아이 추가',
      'main4_babyAddModify' : '아이 추가/수정',
      'main4_InviteBabysitter' : '양육자 / 베이비시터 초대',
      'main4_switch_Alarm' : '알림 ON / OFF',
      'main4_logout' : '로그아웃',
      'main4_modifyUserInfo' : '회원정보 수정',
      'main4_changeLanguage' : '언어모드 변경',
      'main4_withdrawal' : '서비스 탈퇴'
    },
    'en_US':{
      'main4_manageBaby' : 'Manage Baby',
      'main4_addBaby' : 'Add Baby',
      'main4_babyAddModify':'Baby Add/Modify',
      'main4_InviteBabysitter' : 'Invite foster child /Babysitter',
      'main4_switch_Alarm' : 'Alarm ON / OFF',
      'main4_logout' : 'logout',
      'main4_modifyUserInfo' : 'modify user information',
      'main4_changeLanguage' : 'language mode',
      'main4_withdrawal' : 'service withdrawal'
    },
    'de_DE':{
      'hello':'Hallo Welt',
      'home_babyAddModify':'아이 추가/수정'
    },
  };
}