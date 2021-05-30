// import 'dart:io';
// import 'dart:async';
// import 'dart:isolate';
import 'package:flutter/material.dart';
// import 'package:image/image.dart' as IMG;
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:provider/provider.dart';
// import 'package:weighit/models/user_info.dart';

// import 'package:video_trimmer/video_trimmer.dart';
// import 'package:weighit/screens/body_status/detailed_status.dart';

class ToGif extends StatefulWidget {
  @override
  _ToGifState createState() => _ToGifState();
}

class _ToGifState extends State<ToGif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("타임랩스 편집"),
        ),
        backgroundColor: Colors.black);
  }
}

// class TimelapseVideo extends StatefulWidget {
//   final File file;

//   TimelapseVideo(this.file);

//   @override
//   _TimelapseVideoState createState() => _TimelapseVideoState();
// }

// class _TimelapseVideoState extends State<TimelapseVideo> {
//   final Trimmer _trimmer = Trimmer();

//   double _startValue = 0.0;
//   double _endValue = 0.0;

//   bool _isPlaying = false;
//   bool _progressVisibility = false;

//   Future<String> _saveVideo() async {
//     setState(() {
//       _progressVisibility = true;
//     });

//     String _value;

//     await _trimmer
//         .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
//         .then((value) {
//       setState(() {
//         _progressVisibility = false;
//         _value = value;
//       });
//     });

//     return _value;
//   }

//   void _loadVideo() {
//     _trimmer.loadVideo(videoFile: widget.file);
//   }

//   @override
//   void initState() {
//     super.initState();

//     _loadVideo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('타임랩스'),
//       ),
//       body: Builder(
//         builder: (context) => Center(
//           child: Container(
//             padding: EdgeInsets.only(bottom: 30.0),
//             color: Colors.black,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Visibility(
//                   visible: _progressVisibility,
//                   child: LinearProgressIndicator(
//                     backgroundColor: Colors.red,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _progressVisibility
//                       ? null
//                       : () async {
//                           _saveVideo().then((outputPath) {
//                             print('OUTPUT PATH: $outputPath');
//                             final snackBar = SnackBar(
//                                 content: Text('Video Saved successfully'));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               snackBar,
//                             );
//                           });
//                         },
//                   child: Text("SAVE"),
//                 ),
//                 Expanded(
//                   child: VideoViewer(),
//                 ),
//                 Center(
//                   child: TrimEditor(
//                     viewerHeight: 50.0,
//                     viewerWidth: MediaQuery.of(context).size.width,
//                     maxVideoLength: Duration(seconds: 30),
//                     onChangeStart: (value) {
//                       _startValue = value;
//                     },
//                     onChangeEnd: (value) {
//                       _endValue = value;
//                     },
//                     onChangePlaybackState: (value) {
//                       setState(() {
//                         _isPlaying = value;
//                       });
//                     },
//                   ),
//                 ),
//                 TextButton(
//                   child: _isPlaying
//                       ? Icon(
//                           Icons.pause,
//                           size: 80.0,
//                           color: Colors.white,
//                         )
//                       : Icon(
//                           Icons.play_arrow,
//                           size: 80.0,
//                           color: Colors.white,
//                         ),
//                   onPressed: () async {
//                     bool playbackState = await _trimmer.videPlaybackControl(
//                       startValue: _startValue,
//                       endValue: _endValue,
//                     );
//                     setState(() {
//                       _isPlaying = playbackState;
//                     });
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class Thumbnail extends StatefulWidget {
// //   const Thumbnail({Key key}) : super(key: key);
// //   @override
// //   _ThumbnailState createState() => _ThumbnailState();
// // }

// // class _ThumbnailState extends State<Thumbnail> {
// //   List<int> imgBytes;
// //   Isolate isolate;
// //   File image;

// //   @override
// //   void initState() {
// //     _asyncInit();

// //     super.initState();
// //   }

// //   static _isolateEntry(dynamic d) async {
// //     final ReceivePort receivePort = ReceivePort();
// //     d.send(receivePort.sendPort);

// //     final config = await receivePort.first;

// //     print(config);

// //     final file = File(config['path']);
// //     final bytes = await file.readAsBytes();

// //     IMG.Image image = IMG.decodeImage(bytes);
// //     IMG.Image thumbnail = IMG.copyResize(
// //       image,
// //       width: config['size'].width.toInt(),
// //     );

// //     d.send(IMG.encodeNamedImage(thumbnail, basename(config['path'])));
// //   }

// //   _asyncInit() async {
// //     final receivePort = ReceivePort();
// //     isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

// //     receivePort.listen((dynamic data) {
// //       if (data is SendPort) {
// //         if (mounted) {
// //           data.send({
// //             'path': image.path,
// //             'size': Size(500, 500),
// //           });
// //         }
// //       } else {
// //         if (mounted) {
// //           setState(() {
// //             imgBytes = data;
// //           });
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     if (isolate != null) {
// //       isolate.kill();
// //     }
// //     super.dispose();
// //   }

// //   // Download on DocumnetDirectory, not temporary directory https://flutter-ko.dev/docs/cookbook/persistence/reading-writing-files
// //   Future<void> downloadFileExample() async {
// //     final appDocDir = await getApplicationDocumentsDirectory();
// //     image = File('${appDocDir.path}/download-logo.png');

// //     try {
// //       await firebase_storage.FirebaseStorage.instance
// //           // can not find proper reference path...
// //           .ref('gs://weighit-f506b.appspot.com/guny/21-04-26 10:56:21.png')
// //           .writeToFile(image);
// //     } on firebase_core.FirebaseException catch (e) {
// //       print('couldnt find the reference');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final _user = Provider.of<TheUser>(context);
// //     return FutureBuilder(
// //       future: downloadFileExample(),
// //       builder: (context, snapshot) {
// //         //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
// //         if (snapshot.hasData == false) {
// //           return Center(child: CircularProgressIndicator());
// //         }
// //         //error가 발생하게 될 경우 반환하게 되는 부분
// //         else if (snapshot.hasError) {
// //           return Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Text(
// //               'Error: ${snapshot.error}',
// //               style: TextStyle(fontSize: 15),
// //             ),
// //           );
// //         } else {
// //           return SizedBox(
// //             height: 500,
// //             width: 500,
// //             child: imgBytes != null
// //                 ? Image.memory(
// //                     imgBytes,
// //                     fit: BoxFit.cover,
// //                   )
// //                 : Container(
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors: [Colors.grey[100], Colors.grey[300]],
// //                         begin: Alignment.centerLeft,
// //                         end: Alignment.centerRight,
// //                       ),
// //                     ),
// //                   ),
// //           );
// //         }
// //       },
// //     );
// //   }
// // }