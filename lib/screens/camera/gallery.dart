import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';

class gallery extends StatefulWidget {
  @override
  _galleryState createState() => _galleryState();
}

class _galleryState extends State<gallery> {
  List<Card>_buildbuildGridCards(BuildContext context){
    final _user = Provider.of<TheUser>(context);
    if(firebase_storage.FirebaseStorage == null){
      return const <Card>[];
    }
      return Card(
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 18 / 11,
          child: Image.network(
            ,
            fit: BoxFit.fill,
          ),
        ),
      );

  }
  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.play_circle_outline_sharp, color: Colors.black,),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: GridView.count(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 3,
            padding: EdgeInsets.all(16.0),
            childAspectRatio: 8.0/9.0,
            children: [
              _buildGridCards(
              context),
            ],
          ),
        ),
      ),
    );
  }
}
