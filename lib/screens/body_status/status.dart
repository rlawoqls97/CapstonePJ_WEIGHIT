import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:weighit/models/user_info.dart';
import 'package:weighit/services/user_record_DB.dart';

import 'package:weighit/widgets/chart_maker.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  // chartMaker는 차트를 만들어주는 클래스이며, widget folder의 chart_maker.dart에 정의 돼있다.
  ChartMaker chartMaker = ChartMaker();

  UserRecord dummyRecord = UserRecord(
    shoulder: ['어깨', 300, 200, 500, 4],
    chest: ['가슴', 500, 400, 300, 2],
    abs: ['복부', 150, 160, 170, 2],
    arm: ['팔', 200, 210, 205, 3],
    leg: ['하체', 500, 550, 570, 6],
    back: ['등', 400, 420, 450, 3],
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;

    var recordService = RecordDB(uid: user.uid);
    var chartList;

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
      body: FutureBuilder(
          future: _fetchRecord(user.uid),
          builder: (context, snapshot) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (snapshot.hasData == false) {
              return Center(child: CircularProgressIndicator());
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              final chartList =
                  chartMaker.buildListChart(context, snapshot.data);
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16.0),
                childAspectRatio: 8.0 / 8.5,
                children: chartList,
              );
            }
          }),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await recordService.newOverallData();
          await recordService.updateOverallData('등', 200);
          await recordService.updateOverallData('가슴', 300);
          await recordService.updateOverallData('어깨', 400);
          await recordService.updateOverallData('복부', 500);
          await recordService.updateOverallData('하체', 600);
          await recordService.updateOverallData('팔', 700);
        },
        child: Icon(Icons.plus_one_rounded),
      ),
    );
  }

  Future<UserRecord> _fetchRecord(String uid) async {
    var userRecord = UserRecord(
      shoulder: ['어깨'],
      arm: ['팔'],
      chest: ['가슴'],
      abs: ['복부'],
      back: ['등'],
      leg: ['하체'],
    );
    var recordservice = RecordDB(uid: uid);

    // 이틀전 데이터 가져오기
    userRecord = await recordservice.bringRecord(userRecord, 2);
    // 하루전 데이터 가져오기
    userRecord = await recordservice.bringRecord(userRecord, 1);
    // 오늘 데이터 가져오기
    userRecord = await recordservice.bringRecord(userRecord, 0);

    return userRecord;
    //    지금 현재 시간을 기준으로 3일 전까지의 QuerySnapshot을 전부 가져오는 코드
    //    만약 4일 전에 한 운동이라도 -72시간에 한 운동이라면 같이 포함되서 사용하지 않는다.
    // final threedaysbefore = DateTime.now().subtract(Duration(days: 3));
    // FirebaseFirestore.instance
    //     .collection('record')
    //     .doc(user.uid)
    //     .collection('Overall')
    //     .where('timestamp', isGreaterThan: threedaysbefore)
    //     .get()
    //     .catchError((onError) => print('Error'))
    //     .then((QuerySnapshot snapshot) => {
    //           snapshot.docs.forEach((doc) {
    //             // userRecord에다가 적절한 값 집어넣기
    //             print('Query Dummy: ' + doc.get('dummy'));
    //           })
    //         })
    //     .catchError((onError) {
    //   print('Error');
    // });

    //    그냥 QuerySnapshot으로 최근 3개를 일자 순으로 가져오는 코드.
    //    최근 3개가 아니라 최근 3일을 기준으로 가져와야 해서 사용하지 않는다.
    // var snapshot = await FirebaseFirestore.instance
    //     .collection('record')
    //     .doc(uid)
    //     .collection('Overall')
    //     .orderBy('timestamp', descending: false)
    //     .limitToLast(3)
    //     .get();
    // snapshot.docs.forEach((doc) {
    //   // userRecord에다가 적절한 값 집어넣기
    //   print(doc.get('dummy'));
    //   userRecord.shoulder.add(doc.get('어깨') ?? 0);
    //   userRecord.arm.add(doc.get('팔') ?? 0);
    //   userRecord.chest.add(doc.get('가슴') ?? 0);
    //   userRecord.abs.add(doc.get('복부') ?? 0);
    //   userRecord.back.add(doc.get('등') ?? 0);
    //   userRecord.leg.add(doc.get('하체') ?? 0);
    //   // print(userRecord.shoulder);
    // });
  }
}
