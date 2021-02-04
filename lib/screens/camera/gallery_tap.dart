import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';
import 'package:weighit/screens/camera/preview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// ignore: must_be_immutable
class galleryTap extends StatefulWidget {
  List<dynamic> name = [];
  List<dynamic> allUrl = [];
  final String url;
  int index;
  galleryTap({this.name, this.url, this.allUrl, this.index});
  @override
  _galleryTapState createState() => _galleryTapState();
}

class _galleryTapState extends State<galleryTap> {
  int _currentIndex;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance.collection('user');
    final _user = Provider.of<TheUser>(context);
    var val = [];
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${_user.username}')
        .child('${widget.name}.png');
    final size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black,),
                onPressed: () {
                  // reference.doc(_user.uid).delete();
                  // photoUrl.remove(widget.url);

                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            toolbarHeight: size.height * 0.1,
            centerTitle: true,
            // Text('${widget.name}', style: Theme.of(context).textTheme.headline6,),
          ),
          body: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        reverse: false,
                        height: size.height * 0.8,
                        initialPage: widget.index,
                        autoPlay: false,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason){
                          setState(() {
                            _currentIndex = index;
                            first = false;
                            print(_currentIndex);
                          });
                        }
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                            height: size.height * 0.7,
                            width: size.width ,
                            child: Image.network(widget.allUrl[index], fit: BoxFit.fitWidth,)
                        );
                      },
                      itemCount: widget.allUrl.length,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.allUrl.map((url) {
                          var index = widget.allUrl.indexOf(url);
                          return InkWell(
                            onTap: () {

                            },
                            child: Container(
                              width: (_currentIndex == index) ? size.width * 0.1 : size.width * 0.08,
                              height: (_currentIndex == index) ? size.height * 0.1 : size.height * 0.07,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              child: Image.network(widget.allUrl[index]),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
        );
      }
    );
  }
}
