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
        .set({
      'timestamp': DateTime.now(),
      '가슴': 0,
      '등': 0,
      '복부': 0,
      '어깨': 0,
      '팔': 0,
      '하체': 0
    });
  }

  // 새로운 volume을 update할 때
  Future updateOverallData(String part, int volume) async {
    // 만약 해당 부위의 운동을 이미 했으면 volume을 거기에서 더한다.
    int totalVolume;
    await recordCollection
        .doc(uid)
        .collection('Overall')
        .doc(dateTime)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        // 만약 해당 부위의 volume이 이미 있다면 이걸 가져온다.
        totalVolume = doc.get(part) ?? 0;
      } else {
        totalVolume = 0;
      }
    });

    return await recordCollection
        .doc(uid)
        .collection('Overall')
        .doc(dateTime)
        .update({part: totalVolume + volume, 'timestamp': DateTime.now()});
  }

  // Firebase로부터 record를 가져와서 userRecord에 저장하고 다시 return 하는 함수
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

  // 특정한 날의 특정 부위에 대한 값을 가져오는 함수
  Future<List<dynamic>> bringPartialRecord(
      List<dynamic> userRecord, int days, String part) async {
    await FirebaseFirestore.instance
        .collection('record')
        .doc(uid)
        .collection('Overall')
        .doc(DateFormat('yy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: days))))
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        userRecord.add(doc.get(part) ?? 0);
      } else {
        print('record없음');
        userRecord.add(0);
      }
    });

    return userRecord;
  }

  // document가 있는 날(i.e. 운동을 수행한 날) 중 최근 7개를 count해서 가져오는 함수
  Future<List<dynamic>> bringLatestSevenRecord(
      List<dynamic> userRecord, String part) async {
    await FirebaseFirestore.instance
        .collection('record')
        .doc(uid)
        .collection('Overall')
        .orderBy('timestamp')
        .limitToLast(7)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.map((QueryDocumentSnapshot doc) {
        print(doc.get(part) ?? 0);
        userRecord.add([
          doc.get(part) ?? 0,
          DateTime.fromMillisecondsSinceEpoch(
                  doc.get('timestamp').millisecondsSinceEpoch)
              .month,
          DateTime.fromMillisecondsSinceEpoch(
                  doc.get('timestamp').millisecondsSinceEpoch)
              .day
        ]);

        return userRecord;
      }).toList();
    });

    return userRecord;
  }
}
