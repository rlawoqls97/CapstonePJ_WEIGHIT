import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/exercise/exercise_list.dart';
import 'dart:async';

class ExercisingScreen extends StatefulWidget {
  @override
  _ExercisingScreenState createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
  int _setNo = 0;
  int _currentRep = 10;
  int _currentWeight = 40;

  List<UserExercise> exerciseList;
  int exerciseIndex;
  bool isDifferentSet;

  bool isDuringSet = true;

  Timer _timer;
  int _start = 10;
  int selectedTime = 1;

  @override
  void initState() {
    //list <UserExercise> 안에 운동이름, 개수, 무개, 세트를 다 가져와야 함
    exerciseList = [
      UserExercise(name: '벤치프레스', part: '가슴', weight: 40, sets: 3, reps: 12),
      UserExercise(name: '인버티드 로우', part: '등', weight: 60, sets: 5, reps: 10),
    ];
    exerciseIndex = 0;
    //카드 클릭을 통해 ui 변화시키는 boolean variable
    isDifferentSet = false;
    isDuringSet = true;
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      isDuringSet = !isDuringSet;
    });
  }
  // 나중엔 snapshot으로 바꿔와서 바로 읽어야 할듯.
  // _currentRep = exerciseList[exerciseIndex].reps;
  //   _currentWeight = exerciseList[exerciseIndex].weight;

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
        backgroundColor: Color(0xffF8F6F6),
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
                      exerciseList[exerciseIndex].name,
                      style: TextStyle(
                          fontSize: size.height * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _setNo = 0;
                          exerciseIndex++;
                        });
                      },
                      child: Container(
                        height: size.height * 0.1,
                        width: size.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '다음',
                              style: TextStyle(fontSize: size.height * 0.025),
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
                          GestureDetector(
                            onTap: () => setState(() => isDifferentSet = false),
                            child: Text(
                              '전체 세트 동일 설정',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDifferentSet
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => isDifferentSet = true),
                            child: Text(
                              '세트 별 다른 설정',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDifferentSet
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      isDifferentSet
                          ? _differentSetCard(
                              size, exerciseList[exerciseIndex].sets)
                          : _allSetCard(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            isDuringSet ? _setUI(size, _setNo) : _timerUI(size)
          ],
        ),
      ),
    );
  }

  Widget _allSetCard() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          '개수(reps)',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        Slider(
          value: _currentRep.toDouble(),
          activeColor: Color(0xff26E3BC),
          inactiveColor: Colors.white,
          min: 8,
          max: 12,
          divisions: 6,
          onChanged: (val) => setState(() {
            _currentRep = val.round();
          }),
        ),
        SizedBox(
          height: 20,
          child: Text('$_currentRep'),
        ),
        Text(
          '무게(kg)',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        Slider(
          value: _currentWeight.toDouble(),
          activeColor: Color(0xff26E3BC),
          inactiveColor: Colors.white,
          min: 30,
          max: 50,
          divisions: 6,
          onChanged: (val) => setState(() => _currentWeight = val.round()),
        ),
        SizedBox(
          height: 20,
          child: Text('$_currentWeight'),
        ),
      ],
    );
  }

  Widget _differentSetCard(Size size, int sets) {
    var list = ['1', '2', '3'];
    return Column(
        children: list
            .map(
              (val) => Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: size.width * 0.25,
                        height: size.height * 0.04,
                        child: Center(
                          child: Text('세트' + val),
                        )),
                    Container(
                      width: size.width * 0.3,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Color(0xff26E3BC)),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  // setNo--;
                                });
                              },
                            ),
                            Text(
                              // 'setNo'
                              '12',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  // setNo++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.3,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Color(0xff26E3BC)),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  // setNo--;
                                });
                              },
                            ),
                            Text(
                              // 'setNo'
                              '40',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  // setNo++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList()
        // Padding(
        //   padding: EdgeInsets.only(bottom: 5),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       Container(
        //         width: size.width * 0.2,
        //         height: size.height * 0.03,
        //         child: Center(child: Text('세트')),
        //       ),
        //       Container(
        //         width: size.width * 0.3,
        //         height: size.height * 0.03,
        //         child: Center(child: Text('개수(회)')),
        //       ),
        //       Container(
        //         width: size.width * 0.3,
        //         height: size.height * 0.03,
        //         child: Center(child: Text('무게(kg)')),
        //       ),
        //     ],
        //   ),
        // ),

        // 이제 이 list.map을 통해서 set수만큼 iteration을 만들기 + padding과 사이즈 조절하기
//         List<String> list = ['one', 'two', 'three', 'four'];
// List<Widget> widgets = list.map((name) => new Text(name)).toList();

        );
  }

  Widget _setUI(Size size, int setNo) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_setNo >= exerciseList[exerciseIndex].sets) {
                _setNo = 0;
                if (exerciseList.length - 1 > exerciseIndex) {
                  exerciseIndex++;
                }
              } else {
                _toggleUI();
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
                    Text(exerciseList[exerciseIndex].name +
                        ' ${exerciseList[exerciseIndex].sets} Set'),
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
                      maxValue: exerciseList[exerciseIndex]
                          .sets, //나중에 total number of set
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
        Text('1세트의 운동이 끝날 때 마다'),
        Text('핸드폰을 옆으로 흔드세요'),
      ],
    );
  }

  Widget _timerUI(Size size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: size.height * 0.3,
          child: CupertinoPicker(
            // magnification: 1.3,
            children: [
              Text('45.00', style: TextStyle(fontSize: size.height * 0.05)),
              Text('60.00', style: TextStyle(fontSize: size.height * 0.05)),
              Text('90.00', style: TextStyle(fontSize: size.height * 0.05)),
            ],
            itemExtent: size.height * 0.07,
            looping: false,
            onSelectedItemChanged: (index) => selectedTime = index,
          ),
        ),
      ],
    );
  }
}
