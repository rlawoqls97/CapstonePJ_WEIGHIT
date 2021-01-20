import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('test page', style: Theme.of(context).textTheme.headline6,),
        centerTitle: true,
        backgroundColor: Color(0xffF8F6F6),
        toolbarHeight: size.height * 0.1,
      ),
      body: Center(child: Text('Weighit!', style: Theme.of(context).textTheme.headline6,)),
    );
  }
}
