import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/exercise_confirm.dart';
import 'package:weighit/screens/routine/make_routine.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Routine1 extends StatefulWidget {
  @override
  _Routine1State createState() => _Routine1State();
}

class _Routine1State extends State<Routine1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int setNo = 3;
  @override
  Widget build(BuildContext context) {
    // final userExercise = Provider.of<List<UserExercise>>(context) ?? [];
    final _user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    final userExercise = [1, 2, 3];
    return CustomScrollView(
      slivers: [
        SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _exerciseTile(context);
                  },
                childCount: userExercise.length,
              ),
            ),

        SliverFixedExtentList(
          itemExtent: size.height * 0.12,
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: EdgeInsets.fromLTRB(size.width * 0.33,
                    size.height * 0.023, size.width * 0.33, size.height * 0.05),
                child: FlatButton(
                  onPressed: () {

                  },
                  child: Text(
                    '운동 추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  color: Color(0xff26E3BC),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: size.height * 0.07),
                child: Column(
                  children: [
                    Text('선택한 운동', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    Divider(color: Colors.black,),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: size.height * 0.264),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.1,
                    child: FlatButton(
                      color: Color(0xff09255B),
                      child: Text(
                        '새로운 루틴 만들기',
                        style: TextStyle(
                          fontSize: size.height * 0.03,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }

  List<TheUser> _listTiles(BuildContext context, List<DocumentSnapshot> snapshot) {
    if(snapshot == null) {
      return null;
    } else {
      return snapshot.map((doc) {
        return TheUser(
          uid: doc.get('uid') ?? '',
          routine: doc.get('routine') ?? '',
          level: doc.get('level') ?? '',
        );
      }).toList();
    }
  }
  Widget _exerciseTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Card(
        color: Color(0xff09255B),
        child: ListTile(
          onTap: () {},
          title: Text('벤치프레스', style: TextStyle(color: Colors.white),),
        ),
      )
    );
  }
}
