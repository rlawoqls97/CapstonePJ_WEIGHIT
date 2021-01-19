import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/camera/preview.dart';

class gallery extends StatefulWidget {
  @override
  _galleryState createState() => _galleryState();
}

class _galleryState extends State<gallery> {
  Stream<QuerySnapshot> photoStream = FirebaseFirestore.instance.collection('user').snapshots();
  // List<Card>_buildGridCards(BuildContext context, List<DocumentSnapshot> snapshot){
  //   final _user = Provider.of<TheUser>(context);
  //   if(snapshot.isEmpty){
  //     return const <Card>[];
  //   }
  //   return snapshot.map((item) {
  //     return Card(
  //       clipBehavior: Clip.antiAlias,
  //       child: AspectRatio(
  //         aspectRatio: 18 / 11,
  //         child: Image.network(
  //         _user.url[],
  //         fit: BoxFit.fill,
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }
  // List<TheUser> _buildGridCards(BuildContext context, List<DocumentSnapshot> snapshot){
  //   final _user = Provider.of<TheUser>(context);
  //   if(snapshot.isEmpty){
  //     return null;
  //   }
  //   return snapshot.map((item) {
  //     return TheUser(
  //       url: _user.url,
  //     );
  //   }).toList();
  // }
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<TheUser>(context);
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        toolbarHeight: size.height * 0.1,
        title: Text('앨범', style: Theme.of(context).textTheme.headline6,),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black,),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: photoStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(child: Text('사진이 없습니다.'),);
          }
          // final cards = _buildGridCards(context, snapshot.data.docs) ?? [];
          return SingleChildScrollView(
            child: Center(
              child:
              // GridView.builder(
              //   physics: ScrollPhysics(),
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   itemCount: _user.url.length,
              //   // ignore: missing_return
              //   itemBuilder: (context, index){
              //     _cardTiles(context, cards[index]);
              //   },
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 3,
              //     crossAxisSpacing: 1.0,
              //     mainAxisSpacing: 1.0,
              //   ),
              // ),
              GridView.count(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: (snapshot.data.docs.length <= 3) ? snapshot.data.docs.length : 3,
                padding: EdgeInsets.all(6.0),
                childAspectRatio: 8.0 / 9.0,
                children: List.generate(_user.url.length, (index) {
                  return _cardTiles(context, _user, index);
                })

              ),
            ),
          );
        }
      ),
    );
  }
  Widget _cardTiles(BuildContext context, TheUser user, int index){
    // print(user.url);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 18 / 11,
        child: Image.network(
          user.url[index],
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}
