import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ExercisingScreen extends StatefulWidget {
  @override
  _ExercisingScreenState createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
  int _setNo = 0;
  int _currentSet = 10;
  int _currentWeight = 40;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '어깨운동, 초급',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '벤치프레스',
                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        print('다음');
                      },
                      child: Container(
                        height: size.height * 0.1,
                        width: size.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '다음',
                              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12.0),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: size.height * 0.035,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                color: Color(0xffDDF4F0),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '전체 세트 동일 설정',
                            style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black)
                          ),
                          Text(
                            '세트 별 다른 설정',
                            style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black)
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '개수(reps)',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black)
                      ),
                      Slider(
                        value: _currentSet.toDouble(),
                        activeColor: Color(0xff26E3BC),
                        inactiveColor: Colors.white,
                        min: 8,
                        max: 12,
                        divisions: 6,
                        onChanged: (val) =>
                            setState(() => _currentSet = val.round()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '무게(kg)',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black)
                      ),
                      Slider(
                        value: _currentSet.toDouble(),
                        activeColor: Color(0xff26E3BC),
                        inactiveColor: Colors.white,
                        min: 8,
                        max: 12,
                        divisions: 6,
                        onChanged: (val) =>
                            setState(() => _currentSet = val.round()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_setNo >= 5) {
                    _setNo = 0;
                  } else {
                    _setNo++;
                  }
                });
              },
              child: Container(
                width: double.infinity,
                height: size.height * 0.1,
                child: Card(
                  color: Color(0xffCBDBF9),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '벤치프레스 5 Set',
                            style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAProgressBar(
                          changeColorValue: 5,
                          progressColor: Colors.amber[100],
                          changeProgressColor: Colors.amber[800],
                          size: 15,
                          backgroundColor: Colors.white,
                          currentValue: _setNo, //current value는 0부터 max value까지
                          maxValue: 5, //나중에 total number of set
                          displayText: 'sets',
                          displayTextStyle: TextStyle(color: Colors.black),
                        ),
                        //가능하다면 stack으로 set수만큼 공간을 나눈 뒤에 divider 제공
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: Image.asset('assets/shaking.png'),
            ),
            Text('1세트의 운동이 끝날 때 마다', style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),),
            Text('핸드폰을 옆으로 흔드세요', style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),),
          ],
        ),
      ),
    );
  }
}
