import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighit/models/user_info.dart';

class HomePage extends StatelessWidget {
  @override

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('routine').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if ((snapshot.hasError) || (snapshot.data == null)) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final posts = _listTiles(context, snapshot.data.docs) ?? [];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _postTile(context, posts[index]);
            },
          );
        },
      ),
    );
  }
  List<TheUser> _listTiles(BuildContext context, List<DocumentSnapshot> snapshot) {
    if(snapshot == null){
      return null;
    } else {
      return snapshot.map((doc){
        return TheUser(
          uid: doc.get('uid') ?? '',
        );
      }).toList();
    }
  }
  Widget _postTile(BuildContext context, TheUser user){
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Card(
        child: ListTile(
          onTap: () {},
          title: Text(user.uid),
          subtitle: Text(user.uid),
        ),
      ),
    );
  }
}
