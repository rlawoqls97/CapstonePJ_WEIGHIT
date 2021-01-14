import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class StatusChart {
  final String day;
  final int reps;
  final charts.Color barColor;

  StatusChart.fromMap(Map<String, dynamic> map)
      : assert(map['day'] != null),
        assert(map['reps'] != null),
        assert(map['day'] != null),
        day = map['day'],
        reps = map['reps'],
        barColor = map['barColor'];

  StatusChart({this.day, this.reps, this.barColor});
}
