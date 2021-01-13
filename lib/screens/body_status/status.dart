import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weighit/screens/body_status/status_chart.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  final List<StatusChart> data = [
    StatusChart(
      day: 'total',
      reps: 3000,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
    ),
    StatusChart(
      day: 'week',
      reps: 2000,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
    ),
    StatusChart(
      day: 'today',
      reps: 1200,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
    )
  ];
  var list = [2000, 1000, 500];

  // 이 부분에서 넣어주는 parameter 'List<int> record'도 만약 db 연동에서 문제가 날 시 List<dynamic>으로 같이 변환한다.
  List<charts.Series<StatusChart, String>> _buildSingleChart(List<int> record) {
    var chartList = [
      StatusChart(
        day: 'total',
        reps: record[0],
        barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
      ),
      StatusChart(
        day: 'week',
        reps: record[1],
        barColor: charts.ColorUtil.fromDartColor(Color(0xff26E3BC)),
      ),
      StatusChart(
        day: 'today',
        reps: record[2],
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

  // List<InkWell> _buildCharts(BuildContext context) {
  //   return
  // }
  @override
  Widget build(BuildContext context) {
    var status = _buildSingleChart(list);
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '몸 상태',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffF8F6F6),
      ),
      body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: [
            InkWell(
              onTap: () {},
              child: Card(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        '어깨',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          status,
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
                    ],
                  ),
                ),
              ),
            )
          ]),
      resizeToAvoidBottomInset: false,
    );
  }
}
