import 'package:flutter/material.dart';

class ExercisingScreen extends StatefulWidget {
  @override
  _ExercisingScreenState createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '어깨운동, 초급',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffF8F6F6),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('벤치프레스   '),
              Text('다음'),
            ],
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Text('세트조정 카드'),
          ),
          Container(
            width: 200,
            height: 50,
            color: Colors.green,
            child: Text('벤치프레스 5 Set'),
          ),
          Container(
            width: 200,
            height: 50,
            color: Colors.green,
            child: Text('사진'),
          ),
          Container(
            width: 200,
            height: 50,
            color: Colors.green,
            child: Text('1세트의 운동이 끝날 때 마다 핸드폰을 옆으로 흔드세요'),
          ),
        ],
      ),
    );
  }
}
