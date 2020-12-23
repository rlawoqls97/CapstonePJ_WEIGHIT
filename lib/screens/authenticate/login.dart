import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/join_or_login.dart';
import 'package:weighit/services/auth.dart';

//background 용 서클 위젯
class LogInBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // var paint = Paint()..color = Color(0xff25E4BD);
    var paint = Paint()..color = Colors.white;
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.8), size.height * 0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  //sign in 용 카드를 보여줄지, sign up용 카드를 보여줄지 결정하는 변수
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var joinToggle = Provider.of<JoinToggle>(context);
    final size = MediaQuery.of(context).size;
    final showSignUp = joinToggle.isSignUp;

    return Scaffold(
      backgroundColor: Color(0xff09255B),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: size,
                painter: LogInBackground(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Text(
                    'WEIGHIT!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: size.width * 0.3,
                      height: size.width * 0.3,
                      child: Center(child: Text('icon')),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  showSignUp ? _signUpForm(size) : _signInForm(size),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  showSignUp
                      ? RaisedButton.icon(
                          icon: Icon(
                            Icons.backspace,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          label: Text(
                            '돌아가기',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            joinToggle.toggle();
                          },
                        )
                      : RaisedButton(
                          color: Color(0xff25E4BD),
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            joinToggle.toggle();
                            _emailController.clear();
                            _passwordController.clear();
                            error = '';
                          },
                        ),
                  Text('다른 방법으로 로그인 하기'),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          color: Colors.white,
                          onPressed: () {},
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage('assets/apple.jpg'),
                          )),
                      RaisedButton(
                          color: Colors.white,
                          onPressed: () {},
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage('assets/google.jpg'),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _signUpForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 5, 12, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('회원가입 정보 입력',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  // style: TextStyle(color: Colors.black), 만약 유저 text 색 바꾸려면 요거 쓰삼
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    labelText: 'New Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Email을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: 'New Password',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password를 입력해주세요.';
                      }
                      if (value.length < 8) {
                        return '8글자 이상 패스워드를 입력해주세요.';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: RaisedButton(
                    color: Color(0xff25E4BD),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var result = await _auth.registerWithEmailandPassword(
                            _emailController.text, _passwordController.text);
                        if (result == 'weak-password') {
                          setState(() {
                            error = '패스워드가 너무 쉽습니다. 다시 작성해주시겠어요?';
                          });
                        } else if (result == 'email-already-in-use') {
                          setState(() {
                            error = '이미 가입된 이메일입니다.';
                          });
                        }
                        if (result == null) {
                          setState(() {
                            error = '잘못된 이메일 주소입니다.';
                          });
                        }
                      }
                    },
                  ),
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 16, 12, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Email을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password를 입력해주세요.';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: RaisedButton(
                    color: Color(0xff25E4BD),
                    child: Text(
                      'Log IN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      //                 if (e.code == 'user-not-found') {
                      //   print('No user found for that email.');
                      // } else if (e.code == 'wrong-password') {
                      //   print('Wrong password provided for that user.');
                      // }
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
