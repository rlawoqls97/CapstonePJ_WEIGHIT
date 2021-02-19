import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/add_routine/add_routine.dart';
import 'package:weighit/screens/exercise/exercisingScreen.dart';
import 'package:weighit/screens/routine/make_routine.dart';
import 'package:weighit/services/Exercise_database.dart';
import 'package:weighit/services/user_record_DB.dart';

class ExerciseList extends StatefulWidget {
  final String routineName;
  ExerciseList({Key key, this.routineName}) : super(key: key);
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int setNo = 5;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final userExercise = Provider.of<List<UserExercise>>(context) ?? [];
    final exerciseDB =
        ExerciseDB(uid: user.uid, routineName: widget.routineName);
    final size = MediaQuery.of(context).size;

    // void _onReorder(int oldIndex, int newIndex) {
    //   setState(() {
    //     var row = userExercise.removeAt(oldIndex);
    //     _rows.insert(newIndex, row);
    //   });
    // }

    return Column(
      children: [
        Expanded(
            child: CustomScrollView(
          slivers: [
            // 루틴에 있는 운동목록을 stream으로 받아와서 list로 만들기
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _exerciseTile(size, userExercise[index], exerciseDB);
                },
                childCount: userExercise.length,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: size.height * 0.13,
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.33,
                        size.height * 0.025,
                        size.width * 0.33,
                        size.height * 0.05),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddRoutine(
                                    exerciseList: userExercise,
                                    routineName: widget.routineName,
                                  )),
                        );
                      },
                      child: Text('운동 추가하기',
                          style: Theme.of(context).textTheme.subtitle2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
        SizedBox(
          width: double.infinity,
          height: size.height * 0.1,
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              '운동 시작하기',
              style: Theme.of(context).textTheme.headline3,
            ),
            onPressed: () async {
              // 운동 시작하기를 누르면 화면이 넘어가기 전에 그날의 userRecord를 새로 생성한다.
              await RecordDB(uid: user.uid).newOverallData();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExercisingScreen(
                      routineName: widget.routineName,
                      exerciseList: userExercise),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _exerciseTile(
      Size size, UserExercise userExercise, ExerciseDB exerciseDB) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print('tap');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            width: double.infinity,
            height: size.height * 0.09,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userExercise.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    width: size.width * 0.36,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(5, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () async {
                              var sets = userExercise.sets - 1;
                              print('set : $sets');

                              await exerciseDB.updateUserExerciseSet(
                                  userExercise, sets);
                            },
                          ),
                          Text(
                            '${userExercise.sets} set',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              var sets = userExercise.sets + 1;
                              print('set : $sets');

                              await exerciseDB.updateUserExerciseSet(
                                  userExercise, sets);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }
}
