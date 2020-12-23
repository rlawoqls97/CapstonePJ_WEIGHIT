import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/join_or_login.dart';
import 'package:weighit/models/user_info.dart';
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
      return HomePage();
    }
  }
}
