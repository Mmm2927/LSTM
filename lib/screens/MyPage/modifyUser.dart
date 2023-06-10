import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/models/validate.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get.dart' hide Trans;

class ModifyUser extends StatefulWidget {
  final User userinfo;

  const ModifyUser(this.userinfo, {super.key});

  @override
  State<ModifyUser> createState() => _ModifyUser();
}

class _ModifyUser extends State<ModifyUser> {
  late TextEditingController idContoller;
  late TextEditingController passContoller;
  late TextEditingController nameContoller;
  late TextEditingController phoneContoller;

  @override
  void initState() {
    super.initState();
    passContoller = TextEditingController(text: widget.userinfo.password1);
    nameContoller = TextEditingController(text: widget.userinfo.name);
    phoneContoller = TextEditingController(text: widget.userinfo.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('main4_modifyUserInfo'.tr, true),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          drawTitle('login_id'.tr, 0),
                          TextFormField(
                            decoration: formDecoration(widget.userinfo.email),
                            enabled: false,
                          ),
                          drawTitle('login_pass'.tr, 40),
                          TextFormField(
                            controller: passContoller,
                            obscureText: true,
                            decoration: formDecoration(''),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                          drawTitle('login_nickname'.tr, 40),
                          TextFormField(
                            controller: nameContoller,
                            decoration: formDecoration(''),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                          drawTitle('login_phone'.tr, 40),
                          TextFormField(
                            controller: phoneContoller,
                            decoration: formDecoration(''),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 20)
                ],
              ))),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async => await modifyUserinfo(),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color(0xffFF766A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      child: Text('login_modified'.tr,
                          style: const TextStyle(fontSize: 15)))
              ),
            ],
          ),
        ));
  }

  modifyUserinfo() async {
    // 1. validate
    String pass = passContoller.text.trim();
    String name = nameContoller.text.trim();
    String phone = phoneContoller.text.trim();
    if (!validatePassword(pass) &&
        !validateName(name) &&
        !validatePhone(phone)) {
      return;
    }
    // 2. modify
    if (await editUserService(
            {"password": pass, "name": name, "phone": phone}) ==
        "True") {
      // (1) 비번 변경시 -> 내부 저장소 변경
      if (pass != widget.userinfo.password1) {
        await editPasswordLoginStorage(pass); // 내부 저장소 변경
      }
      GET.Get.back(result: {"pass": pass, "name": name, "phone": phone});
    } else {
      GET.Get.snackbar('수정 실패', '수정에 실패하였습니다',
          snackPosition: GET.SnackPosition.TOP,
          duration: const Duration(seconds: 2));
    }
  }
}
