import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/exercise_confirm.dart';
import 'package:weighit/screens/routine/make_routine.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Routine4 extends StatefulWidget {
  @override
  _Routine4State createState() => _Routine4State();
}

class _Routine4State extends State<Routine4> with AutomaticKeepAliveClientMixin<Routine4>{
  int clicked = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int setNo = 3;
  @override
  bool get wantKeepAlive => true;
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
                    setState(() {
                      clicked = clicked + 1;
                    });
                  },
                  child: Text(
                    '운동 추가하기',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  color: Color(0xff26E3BC),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index){
              return Column(
                children: [
                  Divider(color: Colors.black,),
                  Text('선택한 운동', style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),),
                  Divider(color: Colors.black,),
                ],
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            // ignore: missing_return
                (context, index) {
              if (clicked == 0) {
                return Container(
                  child: Center(
                    child: Text('루틴에 추가할 운동을 선택하세요', style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),),
                  ),
                );
              }
              if (clicked > 0) {
                return _chooseExerciseTile(context);
              }
            },
            childCount: 1,
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


  Widget _chooseExerciseTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Card(
        color: Color(0xff09255B),
        child: ListTile(
          onTap: () {},
          title: Text('펙덱 플라이', style: Theme.of(context).textTheme.subtitle2,),
          trailing: IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: () { },),
        ),
      ),
    );
  }


  Widget _exerciseTile(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Card(
          color: Color(0xff09255B),
          child: ListTile(
            onTap: () {},
            title: Text('펙덱 플라이', style: Theme.of(context).textTheme.subtitle2,),
          ),
        )
    );
  }
}
