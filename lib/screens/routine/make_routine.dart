import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:weighit/screens/routine/routine1.dart';
import 'package:weighit/screens/routine/routine2.dart';
import 'package:weighit/screens/routine/routine3.dart';
import 'package:weighit/screens/routine/routine4.dart';
import 'package:weighit/screens/routine/routine5.dart';
import 'package:weighit/screens/routine/routine6.dart';

class Routine extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  final routineController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '새로운 루틴',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
              ),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              tabs: [
                Tab(
                  child: Container(
                    child: Text('가슴',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('어깨',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      '팔',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('등',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('복부',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('하체',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.black)),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Color(0xffF8F6F6),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(child: Routine1()),
                ],
              ),
              Column(
                children: [
                  Expanded(child: Routine2()),
                ],
              ),
              Column(
                children: [
                  Expanded(child: Routine3()),
                ],
              ),
              Column(
                children: [
                  Expanded(child: Routine4()),
                ],
              ),
              Column(
                children: [
                  Expanded(child: Routine5()),
                ],
              ),
              Column(
                children: [
                  Expanded(child: Routine6()),
                ],
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            width: double.infinity,
            height: size.height * 0.1,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                '새로운 루틴 만들기',
                style: TextStyle(
                  fontSize: size.height * 0.025,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        title: Column(
                          children: [
                            Text('새로운 루틴의 이름을 입력하세요'),
                          ],
                        ),
                        content: TextField(
                          cursorColor: Theme.of(context).accentColor,
                          controller: routineController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                            border: OutlineInputBorder(),
                            labelText: 'Ex)가슴운동, 월요일운동',
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              FlatButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
