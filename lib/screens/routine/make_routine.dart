import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/exercise_type.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/routine/routine1.dart';
import 'package:weighit/screens/routine/routine2.dart';
import 'package:weighit/screens/routine/routine3.dart';
import 'package:weighit/screens/routine/routine4.dart';
import 'package:weighit/screens/routine/routine5.dart';
import 'package:weighit/screens/routine/routine6.dart';
import 'package:weighit/services/Exercise_database.dart';
import 'package:weighit/widgets/sliver_header.dart';

class Routine extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> with SingleTickerProviderStateMixin {
  final routineController = TextEditingController();
  TabController _controller;

  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    return StreamProvider(
      create: (_) => ExerciseDB().exercise,
      child: StreamBuilder<List<Exercise>>(
          // 여기서 쓰는 stream을 Exercise_database.dart에서 변경시키기
          stream: ExerciseDB().newExercise,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            final newExercise = snapshot.data;
            return Scaffold(
              body: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            // size: size.height * 0.035,
                          ),
                          Text(
                            '홈',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      '새로운 루틴',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    centerTitle: true,
                    backgroundColor: Color(0xffF8F6F6),
                    pinned: true,
                    expandedHeight: size.height * 0.1,
                    bottom: TabBar(
                      labelColor: Colors.black,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.black),
                      tabs: [
                        Tab(
                          text: '가슴',
                        ),
                        Tab(
                          text: '어깨',
                        ),
                        Tab(
                          text: '팔',
                        ),
                        Tab(
                          text: '등',
                        ),
                        Tab(
                          text: '복부',
                        ),
                        Tab(
                          text: '하체',
                        ),
                      ],
                      controller: _controller,
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        Routine1(),
                        Routine2(),
                        Routine3(),
                        Routine4(),
                        Routine5(),
                        Routine6(),
                      ],
                    ),
                  )
                ],
              ),
              bottomNavigationBar: Container(
                height: size.height * 0.5,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.black,
                          ),
                          Center(
                            child: Text('선택한 운동'),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            height: size.height * 0.33,
                            child: Center(
                              child: snapshot.data.isNotEmpty
                                  ? ListView(
                                      children: snapshot.data
                                          .map((exercise) =>
                                              _chooseExerciseTile(
                                                  context, exercise))
                                          .toList(),
                                    )
                                  : Text(
                                      '루틴에 추가할 운동을 선택하세요',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(color: Colors.black),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      height: size.height * 0.41,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.09,
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
                                      Text(
                                        '새로운 루틴의 이름을 입력하세요',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                  content: TextField(
                                    cursorColor: Theme.of(context).accentColor,
                                    controller: routineController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 6),
                                      border: OutlineInputBorder(),
                                      labelText: '  Ex)가슴운동, 월요일운동',
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        FlatButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          onPressed: () async {
                                            var dataService = ExerciseDB(
                                                uid: user.uid,
                                                routineName:
                                                    routineController.text);
                                            int index = 0;
                                            await dataService
                                                .updateRoutineData();

                                            await newExercise
                                                .forEach((ex) async {
                                              print('$index, ${ex.name}');
                                              await dataService
                                                  .addNewUserExerciseData(
                                                      ex.name,
                                                      ex.part,
                                                      40,
                                                      5,
                                                      12,
                                                      index++);
                                              await dataService
                                                  .deleteNewExerciseData(
                                                      ex.name);
                                            });
                                            Navigator.pop(context);
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
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _chooseExerciseTile(BuildContext context, Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Card(
        color: Color(0xff09255B),
        child: ListTile(
          onTap: () {},
          title: Text(
            exercise.name + '  (${exercise.part})',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () async {
              await ExerciseDB(part: exercise.part)
                  .deleteNewExerciseData(exercise.name);
            },
          ),
        ),
      ),
    );
  }
}
