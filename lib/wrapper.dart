import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/join_or_login.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/UserInformationChange/input_information.dart';
import 'package:weighit/screens/authenticate/login.dart';
import 'package:weighit/screens/home/home.dart';

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
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data.data() != null) {
            user.username = snapshot.data.get('username');
            user.weight = snapshot.data.get('weight');
            user.workedDays = snapshot.data.get('workedDays');
            user.url = snapshot.data.get('url');
            user.pickTime = snapshot.data.get('pickTime');
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
