import 'package:flutter/material.dart';
import 'package:weighit/models/status_chart.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/body_status/detailed_status.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// 이 클래스는 UserRecord 오브젝트를 InkWell of Hero of chart로 변환해주는 메소드를 제공한다.
class ChartMaker {
  // 이 function은 하나의 3 integer list를 chart로 변환해준다.
  // 이 부분에서 넣어주는 parameter 'List<int> record'도 db 연동에서 문제가 나서 List<dynamic>으로 변환했다.
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
  List<InkWell> buildListChart(BuildContext context, UserRecord record) {
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
}
