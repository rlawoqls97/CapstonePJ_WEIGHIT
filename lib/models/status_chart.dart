import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class StatusChart{
  final String day;
  final int reps;
  final charts.Color barColor;

  StatusChart({this.day, this.reps, this.barColor});
}