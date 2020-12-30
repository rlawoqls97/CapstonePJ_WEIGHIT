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
  int setNo = 2;
  @override
  Widget build(BuildContext context) {
    // final userExercise = Provider.of<List<UserExercise>>(context) ?? [];
    final _user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    final userExercise = [1, 2];
    return CustomScrollView(
      slivers: [
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection('routine').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('It breaks before rendering this'),
                    ),
                  )
              );
            }
            if ((snapshot.hasError) || (snapshot.data == null)) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                      child: Text('It breaks before rendering this'),
                  ),
                )
              );
            }
            final posts = _listTiles(context, snapshot.data.docs) ?? [];
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _exerciseTile(context, posts[index]);
                  },
                childCount: userExercise.length,
              ),
            );
          },
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
  Widget _exerciseTile(BuildContext context, TheUser user) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: () {},
          title: Text(user.routine),
        ),
      )
    );
  }
}
