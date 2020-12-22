import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighit/models/user_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: size.height * 0.1,
        child: BottomNavigationBar(
          backgroundColor: Color(0xffF8F7F7),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Color(0xff878787),
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: '내 몸 어때?',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility),
              label: '내 상태는?',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_mosaic),
              label: '내 능력은?',
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.22,
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: size.height * 0.02,left: size.width * 0.04),
                  child: Row(
                    children: [
                      Text('헬스마스터님', style: Theme.of(context).textTheme.headline1,),
                      SizedBox(width: size.width * 0.01,),
                      Text('20일 째 운동중!', style: Theme.of(context).textTheme.headline2,),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: size.height * 0.06, left: size.width * 0.04),
                  child: Row(
                    children: [
                      Text('루틴', style: Theme.of(context).textTheme.headline6,),
                      Container(
                        padding: EdgeInsets.only(left: size.width * 0.47),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text('새로운 루틴 만들기', style: TextStyle(color: Colors.white),),
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
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
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
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: () {},
          title: Text(user.uid),
          subtitle: Text(user.uid, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
