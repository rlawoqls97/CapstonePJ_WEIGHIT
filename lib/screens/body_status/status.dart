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
  final List<StatusChart> data =[
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
  @override
  Widget build(BuildContext context) {
    var status =<charts.Series<StatusChart, String>>[
      charts.Series(

        id: 'Status',
        data: data,
        domainFn: (StatusChart series, _) => series.day,
        measureFn: (StatusChart series, _) => series.reps,
        colorFn: (StatusChart series, _) => series.barColor,
      )
    ];
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
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('어깨', style: TextStyle(color: Colors.white),),
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
                                  )
                              )
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            )
          ]
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}


