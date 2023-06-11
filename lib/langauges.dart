import 'package:get/get.dart';

class Languages extends Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
    'ko_KR':{
      'appbar_login' : '이메일 로그인',
      'appbar_findLogInfo' : '로그인 정보 찾기',
      'appbar_main2' : '홈캠',
      'babyName' : '아기 이름',
      'Init_loginBtn' : '이메일로 로그인',
      'Init_signUpBtn' : '회원가입',
      'Init_Inquiry' : '로그인 문의',
      'login_id' : '아이디',
      'login_pass' : '비밀번호',
      'login_btn' : '로그인',
      'login_nickname' : '닉네임',
      'login_phone' : '휴대폰 번호',
      'login_modified' : '수정 완료',
      'login_findID' : '아이디 찾기',
      'login_findPass' : '비밀번호 찾기',
      'login_successLoginTitle' : '로그인 성공',
      'login_failLoginTitle' : '로그인 실패',
      'login_successLoginContent' : '환영합니다',
      'login_failLoginContent' : '등록된 사용자가 아닙니다',
      'main4_manageBaby' : '아이 관리',
      'main4_addBaby' : '아이 추가',
      'main4_modifyBaby' : '아이 수정',
      'main4_babyAddModify' : '아이 추가/수정',
      'main4_InviteBabysitter' : '양육자 / 베이비시터 초대',
      'main4_switch_Alarm' : '알림 ON / OFF',
      'main4_logout' : '로그아웃',
      'main4_modifyUserInfo' : '회원정보 수정',
      'main4_changeLanguage' : '언어모드 변경',
      'main4_withdrawal' : '서비스 탈퇴',
      'main2_accessWeek' : '접근 가능 요일',
      'main2_accessTime' : '접근 가능 시간',
      'main2_notAccessTitle' : '현재 홈캠에 접근할 수 없습니다.',
      'main4_profileName' : ' 님',
      'main4_profileGreeting' : '좋은 아침 입니다!',
      'main4_profileMyBaby' : '나의 아기',
      'main4_profileAwaitingBaby' : '초대 수락 대기중',
      'withdraw_title' : '회원 탈퇴 안내',
      'withdraw_content' : '지금까지 BoB 서비스를 이용해주셔서 감사합니다.\n회원을 탈퇴하면 BoB 서비스 내 나의 계정 정보 및 근무기록 내역이 삭제되고 복구 할 수 없습니다.',
      'withdraw_checkPhrase' : '위 내용을 숙지하였으며, 동의합니다.',
      'withdraw_btn' : '탈퇴하기',
      'cancle' : '취소',
      'withdraw_finalchekContent' : '탈퇴 시 본인 계정의 모든 기록이 삭제됩니다.\n 탈퇴하시겠습니까?',
      'main4_changeLM' : '언어 모드 변경',
      'accept' : '수락',
      'confirm' : '확인',
      'invitation_Err' : '초대 불가',
      'invitation_ErrC' : '아이를 먼저 등록해 주세요',
      'invitation_invTitle' : '초대 하기',
      'invitation_accept' : '초대 수락',
      'invitation_acceptC' : '초대를 수락하시겠습니까?',
      'invitation_notList' : '미수락 초대들',
      'invitation_invContent' : '공유 코드를 발급해 주세요',
      'invitation2_id' : '초대할 ID',
      'invitation2_idDeco' : '아이디를 입력해 주세요',
      'invitation2_accY' : '접근 요일 선택',
      'invitation2_accT' : '접근 시간 설정',
      'selectBaby' : '아기 선택',
      'relation' : '관계',
      'relation0' : '부모',
      'relation1' : '가족',
      'relation2' : '베이비시터',
      'registration' : '등록',
      'invitation2_setT' : '시간 선택',
      'week0' : '월',
      'week1' : '화',
      'week2' : '수',
      'week3' : '목',
      'week4' : '금',
      'week5' : '토',
      'week6' : '일',
      'birth' : '생일',
      'babyNullErr' : '최소 한명의 아기는 등록되어 있어야 합니다!',
      'babyNameHint' : '아기의 이름 또는 별명을 입력해 주세요',
      'genderF' : '여아',
      'genderM' : '남아',
      'gender' : '성별',
      'modify' : '수정',
      'delete' : '삭제',
      'babyList' : '아기 리스트',
      'babyListC' : '클릭하면 해당 아기를 관리할 수 있습니다.',
      'modi_BabyErr' : '부모 관계인 아기만 수정 가능합니다',
      'life_record' : '생활 기록',
      'grow_record' : '성장 기록',
      'height, weight' : '키, 몸무게',
      'vaccination' : '예방 접종',
      'next_vaccination' : '다음 예방 검진',
      'medical_checkup' : '건강 검진',
      'next_medical_checkup' : '다음 건강 검진',
      'timer_explanation' : '버튼을 길게 누르면 타이머가 작동합니다.',
      'life0' : '모유',
      'life1' : '젖병',
      'life2' : '이유식',
      'life3' : '기저귀',
      'life4' : '수면',
      'put_image' : '사진 첨부',
      'change_image' : '사진 바꾸기',
      'uploaded' : '업로드 되었습니다.',
      'upload' : '업로드',
      'modify' : '수정',
      'modified' : '수정되었습니다',
      'q_delete' : '삭제하시겠습니까?',
      'delete' : '삭제',
      'enter_title' : '제목을 입력하세요.',
      'title' : '제목',
      'enter_content' : '내용을 입력하세요.',
      'content' : '내용',
      'cancel' : '취소',
    },
    'en_US':{
      'appbar_login' : 'Email Login',
      'appbar_findLogInfo' : 'Find login information',
      'appbar_main2' : 'Home cam',
      'babyName' : 'baby name',
      'Init_loginBtn' : 'Sign In by email',
      'Init_signUpBtn' : 'Sign Up',
      'Init_Inquiry' : 'Login inquiry',
      'login_id' : 'ID',
      'login_pass' : 'Password',
      'login_nickname' : 'NickName',
      'login_phone' : 'phone number',
      'login_btn' : 'Login',
      'login_modified' : 'Modified',
      'login_findID' : 'find ID',
      'login_findPass' : 'find Password',
      'login_successLoginTitle' : 'Login Success',
      'login_failLoginTitle' : 'Login Fail',
      'login_successLoginContent' : 'Welcome aboard',
      'login_failLoginContent' : 'Not a registered user',
      'main4_manageBaby' : 'Manage Baby',
      'main4_addBaby' : 'Add Baby',
      'main4_modifyBaby' : 'Modify Baby',
      'main4_babyAddModify':'Baby Add/Modify',
      'main4_InviteBabysitter' : 'Invite foster child /Babysitter',
      'main4_switch_Alarm' : 'Alarm ON / OFF',
      'main4_logout' : 'logout',
      'main4_modifyUserInfo' : 'modify user information',
      'main4_changeLanguage' : 'language mode',
      'main4_withdrawal' : 'service withdrawal',
      'main2_accessWeek' : 'accessible week',
      'main2_accessTime' : 'accessible time',
      'main2_notAccessTitle' : 'You don\'t have access to home cam right now',
      'main4_profileName' : '',
      'main4_profileGreeting' : 'Good Morning!',
      'main4_profileMyBaby' : 'My Baby',
      'main4_profileAwaitingBaby' : 'Waiting invitation',
      'withdraw_title' : 'Notice of withdrawal from membership',
      'withdraw_content' : 'Thank you for using the BoB service until now.\nIf you leave the membership, your account information and work history in the BoB service will be deleted and cannot be recovered.',
      'withdraw_checkPhrase' : 'I understand and agree',
      'withdraw_btn' : 'To withdraw',
      'cancle' : 'Cancle',
      'withdraw_finalchekContent' : 'When you leave, all records in your account will be deleted.\n Would you like to leave?',
      'main4_changeLM' : 'Change language mode',
      'accept' : 'accept',
      'confirm' : 'confirm',
      'invitation_Err' : 'Not Invited',
      'invitation_ErrC' : 'Please register the child first',
      'invitation_invTitle' : 'Inviting',
      'invitation_accept' : 'Accept Invitation',
      'invitation_acceptC' : 'Do you want to accept the invitation?',
      'invitation_notList' : 'missed invitations',
      'invitation_invContent' : 'Please issue a shared code',
      'invitation2_id' : 'ID to invite',
      'invitation2_idDeco' : 'Please enter your ID',
      'invitation2_accY' : 'Set the day of the week to approach',
      'invitation2_accT' : 'Set access time',
      'selectBaby' : 'select a baby',
      'relation' : 'relation',
      'relation0' : 'parents',
      'relation1' : 'family',
      'relation2' : 'babysitter',
      'registration' : 'Registration',
      'invitation2_setT' : 'Select Time',
      'week0' : 'Mon',
      'week1' : 'Tue',
      'week2' : 'Wed',
      'week3' : 'Thu',
      'week4' : 'Fri',
      'week5' : 'Sat',
      'week6' : 'Sun',
      'birth' : 'birth',
      'babyNullErr' : 'At least one baby must be registered!',
      'babyNameHint' : 'put your baby\'s name or nickname',
      'genderF' : 'girl',
      'genderM' : 'boy',
      'gender' : 'Gender',
      'modify' : 'modify',
      'delete' : 'delete',
      'modi_BabyErr' : 'Only babies with parental relationships can be modified',
      'babyList' : 'Baby List',
      'babyListC' : 'Click to manage the baby.',
      'life_record' : 'Life Record',
      'grow_record' : 'Grow Record',
      'height, weight' : 'height, weight',
      'vaccination' : 'Vaccination',
      'next_vaccination' : 'next vaccination',
      'medical_checkup' : 'Medical Check-Up',
      'next_medical_checkup' : 'next medical check-up',
      'timer_explanation' : 'Press and hold the button to start the timer',
      'life0' : 'mom\'s',
      'life1' : 'powder',
      'life2' : 'food',
      'life3' : 'diaper',
      'life4' : 'sleep',
      'put_image' : 'attach picture',
      'change_image' : 'change picture',
      'uploaded' : 'Uploaded.',
      'upload' : 'upload',
      'modify' : 'modify',
      'modified' : 'Modified.',
      'q_delete' : 'Do you want delete this diary?',
      'delete' : 'delete',
      'enter_title' : 'Enter title.',
      'title' : 'title',
      'enter_content' : 'Enter content.',
      'content' : 'content',
      'cancel' : 'cancel',
    },
    'de_DE':{
      'hello':'Hallo Welt',
      'home_babyAddModify':'아이 추가/수정'
    },
  };
}