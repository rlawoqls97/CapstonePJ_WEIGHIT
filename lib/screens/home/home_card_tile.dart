import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/exercise_confirm.dart';
import 'package:weighit/screens/routine/make_routine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CardTile extends StatefulWidget {
  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _user = Provider.of<TheUser>(context);
    return SafeArea(
      child: ListView(
        children: [
          Container(
            height: size.height * 0.24,
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01, left: size.width * 0.04),
                  child: Row(
                    children: [
                      Text(
                        _user.username + '님',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        '${_user.workedDays} 일째 운동중!',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          _auth.signOut();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: size.height * 0.06, left: size.width * 0.04),
                  child: Row(
                    children: [
                      Text(
                        '루틴',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: size.width * 0.47),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Routine()),
                            );
                          },
                          child: Text(
                            '새로운 루틴 만들기',
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
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('routine').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if ((snapshot.hasError) || (snapshot.data == null)) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final posts = _listTiles(context, snapshot.data.docs) ?? [];
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return _postTile(context, posts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<TheUser> _listTiles(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot == null) {
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

  Widget _postTile(BuildContext context, TheUser user) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExerciseConfirm()),
            );
          },
          title: Text(user.routine),
          subtitle: Text(
            user.level,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
