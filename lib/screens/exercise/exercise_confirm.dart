import 'package:flutter/material.dart';

class ExerciseConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('제목'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      // body: ListView(),
      // bottomNavigationBar: FlatButton(
      //   color: Theme.of(context).primaryColor,
      //   child: Text(
      //     '운동 시작하기',
      //     style: Theme.of(context).textTheme.subtitle2,
      //   ),
      //   onPressed: () {},
      // ),

      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Container(),
            ],
          )),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.1,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                '운동 시작하기',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
