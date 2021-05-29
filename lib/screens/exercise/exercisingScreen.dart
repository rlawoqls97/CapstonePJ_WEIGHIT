import 'package:flutter/cupertino.dart';
import 'package:flutter_shake_plugin/flutter_shake_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:weighit/models/user_info.dart';
import 'package:weighit/services/Exercise_database.dart';
import 'package:weighit/services/user_record_DB.dart';
import 'package:weighit/widgets/sliver_header.dart';

class ExercisingScreen extends StatefulWidget {
  final String routineName;
  final List<UserExercise> exerciseList;
  ExercisingScreen({Key key, this.routineName, this.exerciseList})
      : super(key: key);

  @override
  _ExercisingScreenState createState() => _ExercisingScreenState();
}

//총 운동시간, 쉬는 시간 끝나고 보여주는 기능 후에 추가
//
class _ExercisingScreenState extends State<ExercisingScreen> {
  int _setNo;
  int _currentReps;
  int _currentWeight;

  int exerciseIndex;
  bool isDifferentSet;

  bool isDuringSet = true;

  Timer _timer;
  var _time; //실제 줄어들 시간
  int selectedTime = 0;
  bool isTimerRunning;

  FlutterShakePlugin _shakePlugin; //shaking기능을 위한 플러그인 오브젝트

  @override
  void initState() {
    exerciseIndex = 0;
    _setNo = 1;
    //카드 클릭을 통해 ui 변화시키는 boolean variable
    isDifferentSet = false;
    isDuringSet = true;
    isTimerRunning = false;
    _shakePlugin = FlutterShakePlugin(onPhoneShaken: () {
      _toggleUI();
    })
      ..startListening();
    super.initState();
  }

  void startTimer(List<UserExercise> userExercises, BuildContext context) {
    // timer의 duration을 정해주는 역할. 0.01초 단위로 보여줄거니까 duration은 10millisecond로 했다.
    const duration = Duration(milliseconds: 10);
    _timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (_time == 0) {
          setState(() {
            timer.cancel();
            // 전체 exercise의 인덱스를 넘지 않는다면 다음 운동index로 움직임
            if (_setNo == 1) {
              if (userExercises.length - 1 > exerciseIndex) {
                exerciseIndex++;
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }
            isTimerRunning = false;
            isDuringSet = true;
          });
        } else {
          setState(() {
            _time--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakePlugin..stopListening();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      isDuringSet = !isDuringSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    final size = MediaQuery.of(context).size;
    final exerciseDB =
        ExerciseDB(uid: user.uid, routineName: widget.routineName);
    final recordDB = RecordDB(uid: user.uid);
    List<UserExercise> userExercise = widget.exerciseList;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.routineName,
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
                      userExercise[exerciseIndex].name,
                      style: TextStyle(
                          fontSize: size.height * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // 나중엔 차트에 넣기위한 userRecord에도 넣기
                        //exerciseDB.updateALL(userExercise[exerciseIndex]
                        setState(() {
                          if (userExercise.length - 1 > exerciseIndex) {
                            _setNo = 1;
                            exerciseIndex++;
                            if (!isDuringSet) {
                              _toggleUI(); //만약 timer UI를 켜놓고 다음을 눌러서 운동을 바꾸면, 이걸 통해 set ui로 toggle시켜줌
                            }
                            // 만약 slider를 통해 개수나 무게를 움직였다면 db에 반영하기
                            if (_currentReps != null) {
                              // userExercise[exerciseIndex].reps[0] = _currentReps;
                              _currentReps = null;
                            }
                            if (_currentWeight != null) {
                              _currentWeight = null;
                            }
                          } else {
                            Navigator.pop(context);

                            Navigator.pop(context);
                          }
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
                          ? _differentSetCard(size, userExercise[exerciseIndex],
                              context, exerciseDB)
                          : _allSetCard(
                              userExercise[exerciseIndex], exerciseDB),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            isDuringSet
                ? _setUI(size, userExercise)
                : _timerUI(size, context, userExercise, exerciseDB, recordDB)
          ],
        ),
      ),
    );
  }

  //운동의 모든 세트의 반복횟수와 무게가 같은 경우 보여주는 카드
  Widget _allSetCard(UserExercise userExercise, ExerciseDB exerciseDB) {
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
            value: (_currentReps ?? userExercise.reps[0]).toDouble(),
            activeColor: Color(0xff26E3BC),
            inactiveColor: Colors.white,
            min: (userExercise.reps[0] - 3).toDouble(),
            max: (userExercise.reps[0] + 3).toDouble(),
            divisions: 6,
            onChanged: (val) => setState(() => _currentReps = val.round())),
        SizedBox(
          height: 20,
          child: Text('${_currentReps ?? userExercise.reps[0]}'),
        ),
        Text(
          '무게(kg)',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        Slider(
          value: (_currentWeight ?? userExercise.weight[0]).toDouble(),
          activeColor: Color(0xff26E3BC),
          inactiveColor: Colors.white,
          min: (userExercise.weight[0] - 5).toDouble(),
          max: (userExercise.weight[0] + 5).toDouble(),
          divisions: 10,
          onChanged: (val) => setState(() => _currentWeight = val.round()),
        ),
        SizedBox(
          height: 20,
          child: Text('${_currentWeight ?? userExercise.weight[0]}'),
        ),
      ],
    );
  }

  // 운동의 각 세트 별 무게와 반복횟수가 다른 경우 저장하는 것.
  Widget _differentSetCard(Size size, UserExercise userExercise,
      BuildContext context, ExerciseDB exerciseDB) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverHeader(
              Color(0xffDDF4F0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: size.width * 0.25,
                      child: Center(child: Text('세트'))),
                  SizedBox(
                      width: size.width * 0.3,
                      child: Center(child: Text('개수(회)'))),
                  SizedBox(
                      width: size.width * 0.3,
                      child: Center(child: Text('무게(kg)'))),
                ],
              ),
              size.height * 0.05,
              size.height * 0.03),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              child: Center(
                                child: Text('세트${index + 1}'),
                              )),
                          Container(
                            width: size.width * 0.3,
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Color(0xff26E3BC)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () async {
                                      setState(() {
                                        userExercise.reps[index]--;
                                      });
                                      await exerciseDB
                                          .updateUserExerciseReps(userExercise);
                                    },
                                  ),
                                  Text(
                                    ('${userExercise.reps[index]}'),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () async {
                                      setState(() {
                                        userExercise.reps[index]++;
                                      });
                                      await exerciseDB
                                          .updateUserExerciseReps(userExercise);
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Color(0xff26E3BC)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () async {
                                      setState(() {
                                        userExercise.weight[index]--;
                                      });
                                      await exerciseDB.updateUserExerciseWeight(
                                          userExercise);
                                    },
                                  ),
                                  Text(
                                    ('${userExercise.weight[index]}'),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () async {
                                      setState(() {
                                        userExercise.weight[index]++;
                                      });
                                      await exerciseDB.updateUserExerciseWeight(
                                          userExercise);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                childCount: userExercise.sets),
          ),
        ],
      ),
    );
  }

  Widget _setUI(Size size, List<UserExercise> userExercises) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              // 폰을 흔들거나 setUI를 클릭하면 timer로 넘어가기
              _toggleUI();
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
                    Text(userExercises[exerciseIndex].name +
                        ' ${userExercises[exerciseIndex].sets} Set'),
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
                      maxValue: userExercises[exerciseIndex].sets,
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

  Widget _timerUI(
      Size size,
      BuildContext context,
      List<UserExercise> userExercises,
      ExerciseDB exerciseDB,
      RecordDB recordDB) {
    return Column(
      children: [
        // Text('$_start'),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: size.height * 0.3,
          child: isTimerRunning
              ? Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_time ~/ 100}', //초
                      style: TextStyle(fontSize: size.height * 0.05),
                    ),
                    Text(
                      '.${_time % 100}'.padLeft(2, '0'), //소숫점 시간
                      style: TextStyle(fontSize: size.height * 0.03),
                    ),
                  ],
                ))
              : CupertinoPicker(
                  // magnification: 1.3,
                  children: [
                    Text('45.00',
                        style: TextStyle(fontSize: size.height * 0.05)),
                    Text('60.00',
                        style: TextStyle(fontSize: size.height * 0.05)),
                    Text('90.00',
                        style: TextStyle(fontSize: size.height * 0.05)),
                  ],
                  itemExtent: size.height * 0.07,
                  looping: false,
                  onSelectedItemChanged: (index) => selectedTime = index,
                ),
        ),
        isTimerRunning
            ? FlatButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  '넘기기',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  int volume = 0;
                  if (_setNo == 1) {
                    // 다음 운동으로 넘어갈 때 운동의 정보를 사용자의 record에 저장 먼저하기

                    for (int v = 0;
                        v < userExercises[exerciseIndex].sets;
                        v++) {
                      volume += (userExercises[exerciseIndex].reps[v] *
                          userExercises[exerciseIndex].weight[v]);
                      print(volume);
                    }

                    await recordDB.updateOverallData(
                        userExercises[exerciseIndex].part, volume);
                  }
                  setState(() {
                    ///////////////////////////////////////
                    ///timer를 캔슬 시키고, 다음 운동으로 넘기는 기능
                    _timer.cancel();
                    // 전체 exercise의 인덱스를 넘지 않는다면 다음 운동index로 움직임
                    if (_setNo == 1) {
                      // 그 다음에 다음 운동으로 넘어가거나 운동이 끝났으면 메인 화면으로 나간다.
                      if (userExercises.length - 1 > exerciseIndex) {
                        exerciseIndex++;
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }

                    isTimerRunning = !isTimerRunning;
                    isDuringSet = !isDuringSet;
                    selectedTime = 0;
                  });
                },
              )
            : FlatButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  '쉬기',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    // 만약 모든 세트를 수행한 경우 아래의 if문을 거쳐서 다음 운동으로 넘어간다.
                    if (_setNo >= userExercises[exerciseIndex].sets) {
                      _setNo = 1;
                      // 만약 slider를 통해 전체 세트 동일 설정으로 반복횟수를 움직였다면 db에 반영하기
                      if (_currentReps != null) {
                        userExercises[exerciseIndex].reps[0] = _currentReps;
                        _currentReps = null;

                        exerciseDB.updateUserExerciseAllReps(
                            userExercises[exerciseIndex]);
                      }
                      // 만약 slider를 통해 전체 세트 동일 설정으로 무게를 움직였다면 db에 반영하기
                      if (_currentWeight != null) {
                        userExercises[exerciseIndex].weight[0] = _currentWeight;

                        _currentWeight = null;

                        exerciseDB.updateUserExerciseAllWeight(
                            userExercises[exerciseIndex]);
                      }
                    } else {
                      _setNo++;
                    }
                    startTimer(userExercises, context);
                    isTimerRunning = !isTimerRunning;
                    switch (selectedTime) {
                      case 0:
                        _time = 300;

                        break;
                      case 1:
                        _time = 600;
                        break;
                      case 2:
                        _time = 900;
                        break;
                    }

                    selectedTime = 0; //다시 45초 타이머로 돌려놓기
                  });
                },
              ),
        Text('주어진 시간 동안 휴식하세요'),
      ],
    );
  }
}
