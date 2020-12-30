import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:weighit/screens/body_status/status_chart.dart';

class StatusData extends StatelessWidget {
  final List<StatusChart> data;
  StatusData({this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StatusChart, String>> status =[
      charts.Series(
        id: 'Status',
        data: data,
          domainFn: (StatusChart series, _) => series.day,
          measureFn: (StatusChart series, _) => series.reps,
          colorFn: (StatusChart series, _) => series.barColor
      )
    ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('어깨'),
              Expanded(
                child: charts.BarChart(status, animate: true,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
