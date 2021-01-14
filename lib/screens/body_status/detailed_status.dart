import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weighit/models/status_chart.dart';

class DetailedStatus extends StatelessWidget {
  final List<dynamic> record;

  DetailedStatus({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          pinned: true,
          expandedHeight: size.height * 0.2,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(record[0]),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: Theme.of(context).primaryColor,
                height: 500.0,
                child: Hero(
                  tag: record[0],
                  child: Card(
                    elevation: 10,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
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
              ),
              Container(color: Colors.purple, height: 300.0),
              Container(color: Colors.green, height: 150.0),
            ],
          ),
        )
      ],
    );
  }

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
}
