import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/exercise_list.dart';
import 'package:weighit/services/Exercise_database.dart';

class ExerciseConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    return StreamProvider<List<UserExercise>>(
      create: (_) => ExerciseDB(uid: user.uid).userExercise,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              '어깨운동, 초급',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Color(0xffF8F6F6),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(child: ExerciseList()),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.1,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    '운동 시작하기',
                    style: TextStyle(
                      fontSize: size.height * 0.03,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          )),
    );
  }
}
