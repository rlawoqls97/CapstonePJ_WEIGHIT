import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/exercise_type.dart';
import 'package:weighit/models/user_info.dart';
import 'abs.dart';
import 'chest.dart';
import 'arm.dart';
import 'shoulder.dart';
import 'back.dart';
import 'leg.dart';
import 'package:weighit/services/Exercise_database.dart';

class AddRoutine extends StatefulWidget {
  List<UserExercise> exerciseList;
  final String routineName;

  AddRoutine({Key key, this.exerciseList, this.routineName}) : super(key: key);
  @override
  _AddRoutineState createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine>
    with SingleTickerProviderStateMixin {
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
                      '루틴에 운동 추가하기',
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
                        Chest(),
                        Shoulder(),
                        Arm(),
                        Back(),
                        Abs(),
                        Leg(),
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
                          '루틴에 운동 추가하기',
                          style: TextStyle(
                            fontSize: size.height * 0.025,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        onPressed: () async {
                          var dataService = ExerciseDB(
                              uid: user.uid, routineName: widget.routineName);
                          int index = widget.exerciseList.length;
                          await dataService.updateUserRoutineData();

                          await newExercise.forEach((ex) async {
                            print('$index, ${ex.name}');
                            await dataService.addNewUserExerciseData(
                                ex.name, ex.part, 40, 5, 12, index++);
                            await dataService.deleteNewExerciseData(ex.name);
                          });
                          Navigator.pop(context);
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
