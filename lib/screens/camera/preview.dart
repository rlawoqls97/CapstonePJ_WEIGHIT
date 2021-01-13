import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  PreviewScreen({this.imgPath, this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          toolbarHeight: size.height * 0.1,
          title: Text('찍은 사진', style: Theme.of(context).textTheme.headline6,),
          centerTitle: true,
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: () {},
              icon: Icon(Icons.done),
            )
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.share,color: Colors.white,),
                      onPressed: (){
                        getBytes().then((bytes) {
                          print('here now');
                          print(widget.imgPath);
                          print(bytes.buffer.asUint8List());
                          Share.file('Share via', widget.fileName, bytes.buffer.asUint8List(), 'image/path');
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Future getBytes () async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}