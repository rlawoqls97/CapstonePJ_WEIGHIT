import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:weighit/screens/routine/routine1.dart';


class Routine extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: Text('새로운 루틴', style: TextStyle(color: Colors.black),),
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
              ),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              tabs: [
                Tab(child: Container(
                  child: Text('가슴', style: TextStyle(color: Colors.black),),
                ),),
                Tab(child: Container(
                  child: Text('어깨', style: TextStyle(color: Colors.black),),
                ),),
                Tab(child: Container(
                  child: Text('팔', style: TextStyle(color: Colors.black),),
                ),),
                Tab(child: Container(
                  child: Text('등', style: TextStyle(color: Colors.black),),
                ),),
                Tab(child: Container(
                  child: Text('복부', style: TextStyle(color: Colors.black),),
                ),),
                Tab(child: Container(
                  child: Text('하체', style: TextStyle(color: Colors.black),),
                ),),
              ],
            ),
            centerTitle: true,
            backgroundColor: Color(0xffF8F6F6),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: TabBarView(
            children: [
              Routine1(),
              Text('가슴'),
              Text('가슴'),
              Text('가슴'),
              Text('가슴'),
              Text('가슴'),
            ],
          ),
        ),
      ),
    );
  }
}
