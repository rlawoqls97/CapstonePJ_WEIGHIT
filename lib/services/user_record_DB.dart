import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:weighit/models/user_info.dart';

//
// 이것은 user의 운동량 (= volume)을 날짜별/부위별로 save&load하기 위한 database service용 클래스다.
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

  // Firebase로부터 record를 가져와서 userRecord에 적용할 때
  Future<UserRecord> bringRecord(UserRecord userRecord, int days) async {
    await FirebaseFirestore.instance
        .collection('record')
        .doc(uid)
        .collection('Overall')
        .doc(DateFormat('yy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: days))))
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        // print(doc.get('dummy'));
        userRecord.shoulder.add(doc.get('어깨'));
        userRecord.arm.add(doc.get('팔'));
        userRecord.chest.add(doc.get('가슴'));
        userRecord.abs.add(doc.get('복부'));
        userRecord.back.add(doc.get('등'));
        userRecord.leg.add(doc.get('하체'));
      } else {
        print('record없음');
        userRecord.shoulder.add(0);
        userRecord.arm.add(0);
        userRecord.chest.add(0);
        userRecord.abs.add(0);
        userRecord.back.add(0);
        userRecord.leg.add(0);
      }
    });

    return userRecord;
  }
}
