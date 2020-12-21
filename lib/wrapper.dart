import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return either Home or Login widget depending on AuthService.user stream
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return Container(child: Text('Home'));
    }
  }
}
