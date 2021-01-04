import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/routine/make_routine.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int setNo = 5;
  @override
  Widget build(BuildContext context) {
    // final userExercise = Provider.of<List<UserExercise>>(context) ?? [];
    final size = MediaQuery.of(context).size;

    final userExercise = [1, 2];
    return CustomScrollView(
      slivers: [
        // 루틴에 있는 운동목록을 stream으로 받아와서 list로 만들기
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _exerciseTile(size);
            },
            childCount: userExercise.length,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: size.height * 0.13,
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: EdgeInsets.fromLTRB(size.width * 0.33,
                    size.height * 0.025, size.width * 0.33, size.height * 0.05),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Routine()),
                    );
                  },
                  child: Text(
                    '운동 추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
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
    );
  }

  Widget _exerciseTile(Size size) {
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
                    '딥스',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    width: size.width * 0.34,
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
                            onPressed: () {
                              setState(() {
                                setNo--;
                              });
                            },
                          ),
                          Text(
                            '$setNo set',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                setNo++;
                              });
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
