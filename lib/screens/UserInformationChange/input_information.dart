import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/services/Exercise_database.dart';

class InputInformation extends StatelessWidget {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('회원 정보 입력'),
        toolbarHeight: size.height * 0.1,
        centerTitle: true,
        actions: [],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, size.height * 0.2, 20, 5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        child: Text(
                          '사용자 이름',
                          style: TextStyle(fontSize: size.height * 0.025),
                        ),
                      ),
                      Container(
                        width: size.width * 0.55,
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                          ),
                          controller: _nameController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return '사용자명을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        child: Text(
                          '체중',
                          style: TextStyle(fontSize: size.height * 0.025),
                        ),
                      ),
                      Container(
                        width: size.width * 0.55,
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                          ),
                          controller: _weightController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return '체중을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: size.height * 0.1,
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(user.uid)
                              .set({
                                'uid': user.uid,
                                'username': _nameController.text,
                                'weight': int.parse(_weightController.text),
                                'email':
                                    FirebaseAuth.instance.currentUser.email ??
                                        '',
                                'workedDays': 0,
                                'url': [],
                                'pickTime': [],
                              })
                              .then((value) => print('Item added'))
                              .catchError(
                                  (error) => print('Failed add Item : $error'));

                          // 기본 루틴 넣어주기
                          var defaultRoutine1 = ExerciseDB(
                              uid: user.uid,
                              routineName: '독일 역도 선수 운동법! GVT (등)');
                          await defaultRoutine1.updateUserRoutineData();
                          await defaultRoutine1.addNewUserExerciseData(
                              '랫 풀 다운', '등', 40, 10, 10, 0);
                          await defaultRoutine1.addNewUserExerciseData(
                              '덤벨 플라이', '등', 25, 4, 12, 1);
                          await defaultRoutine1.addNewUserExerciseData(
                              '와이드 그립 로우', '등', 40, 4, 12, 2);
                          // 기본 루틴 넣어주기
                          var defaultRoutine2 = ExerciseDB(
                              uid: user.uid,
                              routineName: '독일 역도 선수 운동법! GVT (하체)');
                          await defaultRoutine2.updateUserRoutineData();

                          await defaultRoutine2.addNewUserExerciseData(
                              '스쿼트', '하체', 60, 10, 10, 0);
                          await defaultRoutine2.addNewUserExerciseData(
                              '루마니안 데드리프트', '하체', 70, 4, 12, 1);
                          await defaultRoutine2.addNewUserExerciseData(
                              '런지', '하체', user.weight, 4, 12, 2);
                        }
                      },
                      label: Text(
                        '시작하기',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
