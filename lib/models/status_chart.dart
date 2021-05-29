import 'package:charts_flutter/flutter.dart' as charts;

class StatusChart {
  final String day;
  final int reps;
  final charts.Color barColor;

  StatusChart.fromMap(Map<String, dynamic> map)
      : assert(map['day'] != null),
        assert(map['reps'] != null),
        assert(map['day'] != null),
        day = map['day'],
        reps = map['reps'], //<= 이거 이름 나중에 volume으로 바꿔주기
        barColor = map['barColor'];

  StatusChart({this.day, this.reps, this.barColor});
}
