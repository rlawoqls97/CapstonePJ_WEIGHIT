import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';

import 'package:weighit/screens/body_status/detailed_status.dart';
import 'package:weighit/widgets/chart_maker.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  UserRecord dummyRecord = UserRecord(
    shoulder: ['어깨', 2000, 1000, 500, 4],
    arm: ['팔', 500, 100, 500, 5],
    chest: ['가슴', 2000, 1000, 500, 6],
    abs: ['복근', 300, 1000, 500, 5],
    back: ['등', 2000, 1000, 500, 3],
    leg: ['다리', 200, 1000, 500, 2],
  );

  // chartMaker는 차트를 만들어주는 widget으로 widget folder의 chart_maker.dart에 정의 되있다.
  ChartMaker chartMaker = ChartMaker();
  @override
  Widget build(BuildContext context) {
    final chartList = chartMaker.buildListChart(context, dummyRecord);
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '몸 상태',
            style: Theme.of(context).textTheme.headline6,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF8F6F6),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 8.5,
        children: chartList,
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
