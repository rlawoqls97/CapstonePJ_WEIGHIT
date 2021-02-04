import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;
import 'package:weighit/models/status_chart.dart';

class DetailedStatus extends StatelessWidget {
  List<dynamic> record;

  DetailedStatus({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey,
          elevation: 0,
          pinned: false,
          expandedHeight: size.height * 0.2,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(record[0]),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            maxHeight: size.height * 0.1,
            minHeight: size.height * 0.05,
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 500.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.049,
                    child: Center(
                      child: Text(
                        'Daily',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.049,
                    child: Center(
                      child: Text(
                        'Weekly',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.049,
                    child: Center(
                      child: Text(
                        'Monthly',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                animate: false,
                                defaultRenderer:
                                    charts.BarRendererConfig(strokeWidthPx: 5),
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
              Container(
                color: Theme.of(context).primaryColor,
                height: 500.0,
                child: Text(
                  '다른 정보들',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
