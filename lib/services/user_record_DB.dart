import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:weighit/models/user_info.dart';

//
// 이것은 user의 운동량 (= volume)을 날짜별/부위별로 저장하기 위한 database service용 클래스다.
//
class RecordDB {
  final String uid;
  RecordDB({this.uid});

  final String dateTime = DateFormat('yy-MM-dd').format(DateTime.now());
  final CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('record');

  // 새로운 record를 만들 때
  Future newOverallData() async {
    return await recordCollection
        .doc(uid)
        .collection('Overall')
        .doc(dateTime)
        .set({'timestamp': DateTime.now()});
  }

  // 새로운 volume을 update할 때
  Future updateOverallData(String part, int volume) async {
    return await recordCollection
        .doc(uid)
        .collection('Overall')
        .doc(dateTime)
        .update({part: volume, 'timestamp': DateTime.now()});
  }

  Future record() async {
    return await recordCollection
        .doc(uid)
        .collection('Overall')
        .orderBy('timestamp')
        .limitToLast(3)
        .get()
        .then((value) => null);
    // return FirebaseFirestore.instance
    //     .collection('newRoutine')
    //     .snapshots()
    //     .map(_exerciseListFromSnapshot);
  }
}
