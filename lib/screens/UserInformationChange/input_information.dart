import 'package:flutter/material.dart';

class InputInformation extends StatelessWidget {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffCBDBF9),
        title: Text('회원 정보 입력'),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    '사용자 이름',
                    style: TextStyle(fontSize: size.height * 0.025),
                  ),
                ),
                Container(
                  width: size.width * 0.55,
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                    ),
                    controller: _nameController,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    '체중',
                    style: TextStyle(fontSize: size.height * 0.025),
                  ),
                ),
                Container(
                  width: size.width * 0.55,
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                    ),
                    controller: _weightController,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: SizedBox(
                width: 240,
                height: 240,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.camera,
                    size: 40,
                  ),
                  label: Text(
                    '시작하기',
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
