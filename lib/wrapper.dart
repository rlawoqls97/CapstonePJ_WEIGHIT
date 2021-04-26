import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/join_or_login.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/UserInformationChange/input_information.dart';
import 'package:weighit/screens/authenticate/login.dart';
import 'package:weighit/screens/home/home.dart';
import 'package:weighit/services/user_info_DB.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either Home or Login widget depending on AuthService.user stream
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return ChangeNotifierProvider<JoinToggle>(
        create: (_) => JoinToggle(),
        child: LogIn(),
      );
    } else {
      return StreamBuilder<TheUser>(
        stream: UserDB(uid: user.uid).userInfo,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data != null) {
            // 만약 user에 추가될 field가 필요하다면, Model의 TheUser class와 services의 user_info_DB.dart에도 추가 수정하면 된다.
            UserDB(uid: user.uid).inputUserInfotoProvider(user, snapshot.data);
            return HomePage();
          } else {
            //만약 유저의 data가 없으면 최초 정보 입력 화면으로 간다.
            return InputInformation();
          }
        },
      );
    }
  }
}
