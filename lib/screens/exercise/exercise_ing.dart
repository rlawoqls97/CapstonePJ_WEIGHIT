import 'package:flutter/material.dart';

class ExercisingScreen extends StatefulWidget {
  @override
  _ExercisingScreenState createState() => _ExercisingScreenState();
}

class _ExercisingScreenState extends State<ExercisingScreen> {
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
                      '벤치프레스',
                      style: TextStyle(
                          fontSize: size.height * 0.035,
                          fontWeight: FontWeight.bold),
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
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('고르는 부분'),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: size.height * 0.083,
              color: Color(0xffCBDBF9),
              child: Text('벤치프레스 5 Set'),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: Image.asset('assets/shaking.png'),
            ),
            Text('1세트의 운동이 끝날 때 마다'),
            Text('핸드폰을 옆으로 흔드세요'),
          ],
        ),
      ),
    );
  }
}
