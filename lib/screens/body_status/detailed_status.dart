import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:weighit/models/status_chart.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/services/user_record_DB.dart';
import 'package:weighit/widgets/chart_maker.dart';

enum Time { Daily, Weekly, History }

class DetailedStatus extends StatefulWidget {
  List<dynamic> record;

  DetailedStatus({Key key, this.record}) : super(key: key);

  @override
  _DetailedStatusState createState() => _DetailedStatusState();
}

class _DetailedStatusState extends State<DetailedStatus> {
  Time time = Time.Daily;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: _fetchRecord(user.uid, time, widget.record[0]),
        builder: (context, snapshot) {
          var record = snapshot.data;
          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xffF8F6F6),
                  leading: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  pinned: false,
                  expandedHeight: size.height * 0.08,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      widget.record[0],
                      style: TextStyle(
                          color: Colors.black, fontSize: size.height * 0.021),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    maxHeight: size.height * 0.1,
                    minHeight: size.height * 0.05,
                    child: Container(
                      color: Color(0xffF8F6F6),
                      height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 이제 여기서 각 컨테이너를 누를 때마다 적절하게 time을 바꿔줘서 새롭게 만들어야 한다.
                          Container(
                            height: size.height * 0.049,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  time = Time.Daily;
                                });
                              },
                              child: Center(
                                child: Text(
                                  'Daily',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.049,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  time = Time.Weekly;
                                });
                              },
                              child: Center(
                                child: Text(
                                  'Weekly',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.049,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  time = Time.History;
                                });
                              },
                              child: Center(
                                child: Text(
                                  'History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.black),
                                ),
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
                      // 어떤 time을 골랐는지에 따라 적절한 graph를 return하는 function이다.
                      time == Time.Daily
                          ? _chooseGraph(time, widget.record)
                          : _chooseGraph(time, record),
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
                )
              ],
            );
          }
        });
  }
}

Future<List<dynamic>> _fetchRecord(String uid, Time time, String part) async {
  List<dynamic> userRecord = [];
  var recordservice = RecordDB(uid: uid);

  switch (time) {
    case Time.Weekly:
      userRecord = await recordservice.bringPartialRecord(userRecord, 6, part);
      userRecord = await recordservice.bringPartialRecord(userRecord, 5, part);
      userRecord = await recordservice.bringPartialRecord(userRecord, 4, part);
      userRecord = await recordservice.bringPartialRecord(userRecord, 3, part);
      continue after;
    after:
    case Time.Daily:
      // 이틀전 데이터 가져오기
      userRecord = await recordservice.bringPartialRecord(userRecord, 2, part);
      // 하루전 데이터 가져오기
      userRecord = await recordservice.bringPartialRecord(userRecord, 1, part);
      // 오늘 데이터 가져오기
      userRecord = await recordservice.bringPartialRecord(userRecord, 0, part);
      break;
    case Time.History:
  }
  print(userRecord);

  return userRecord;
}

Widget _chooseGraph(Time time, List<dynamic> record) {
  switch (time) {
    case Time.Daily:
      return Container(
        color: Colors.white,
        height: 300.0,
        child: Hero(
          tag: record[0],
          child: ChartMaker().buildChartThreeDays(record),
        ),
      );
      break;
    case Time.Weekly:
      return Container(
        color: Colors.white,
        height: 300.0,
        child: ChartMaker().buildChartSevenDays(record),
      );
      break;
    case Time.History:
      return Container(
        height: 300.0,
        child: Text('History'),
      );
      break;
    default:
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
