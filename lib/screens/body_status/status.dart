import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weighit/models/status_chart.dart';
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

  // 이 function은 하나의 3 integer list를 chart로 변환해준다.
  // 이 부분에서 넣어주는 parameter 'List<int> record'도 만약 db 연동에서 문제가 날 시 List<dynamic>으로 같이 변환한다.
  List<charts.Series<StatusChart, String>> _buildSingleChart(
      List<dynamic> record) {
    var chartList = [
      StatusChart(
        day: 'total',
        reps: record[1],
        barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
      ),
      StatusChart(
        day: 'week',
        reps: record[2],
        barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
      ),
      StatusChart(
        day: 'today',
        reps: record[3],
        barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
      )
    ];
    //일단 StatusChart list에 chart data들을 넣어주고, 이를 chart 전용 status값들로 바꿔준다.
    return <charts.Series<StatusChart, String>>[
      charts.Series(
        id: 'Status',
        data: chartList,
        domainFn: (StatusChart series, _) => series.day,
        measureFn: (StatusChart series, _) => series.reps,
        colorFn: (StatusChart series, _) => series.barColor,
      )
    ];
  }

  // 위의 _buildSingleChart를 통해서 여섯 부위의 chart list를 만든다.
  List<InkWell> _buildListChart(UserRecord record) {
    return [
      record.shoulder,
      record.arm,
      record.chest,
      record.abs,
      record.back,
      record.leg,
    ] //여기서 만든 6개의 integer list를 InkWell Card로 바꿔준다.
        .map((record) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // 나중에 꼭 provider로 firebase user record document를 넘기기!
              //
              builder: (BuildContext context) => DetailedStatus(
                record: record,
              ),
            ),
          );
        },
        child: Hero(
          tag: record[0],
          child: Card(
            elevation: 10,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        record[0],
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'LV.${record[4]}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: charts.BarChart(
                        _buildSingleChart(record),
                        animate: true,
                        primaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                              fontSize: 12,
                              color: charts.MaterialPalette.white,
                            ),
                          ),
                        ),
                        domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                                labelStyle: charts.TextStyleSpec(
                          fontSize: 12,
                          color: charts.MaterialPalette.white,
                        ))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  ChartMaker chartMaker = ChartMaker();
  @override
  Widget build(BuildContext context) {
    final chartList = _buildListChart(dummyRecord);
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
