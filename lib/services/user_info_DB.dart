import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighit/models/user_info.dart';

class UserDB {
  final String uid;

  UserDB({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  void inputUserInfotoProvider(TheUser providerUser, TheUser user) {
    providerUser.username = user.username;
    providerUser.weight = user.weight;
    providerUser.workedDays = user.workedDays;
    providerUser.url = user.url;
    providerUser.pickTime = user.pickTime;
    providerUser.pickedUrl = user.pickedUrl;
  }

  // UserExercise list from snapshot
  TheUser _userInfoFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null || !snapshot.exists) {
      return null;
    } else {
      return TheUser(
          uid: uid,
          username: snapshot.get('username'),
          weight: snapshot.get('weight'),
          workedDays: snapshot.get('workedDays'),
          url: snapshot.get('url'),
          pickTime: snapshot.get('pickTime'),
          pickedUrl: snapshot.get('pickedUrl')
          // name: doc.get('name') ?? '',
          // part: doc.get('part') ?? '',
          // weight: doc.get('weight') ?? [0],
          // sets: doc.get('sets') ?? 0,
          // reps: doc.get('reps') ?? [0],
          // index: doc.get('index'),
          );
    }
  }

  // get userExercise stream
  Stream<TheUser> get userInfo {
    return userCollection.doc(uid).snapshots().map(_userInfoFromSnapshot);
  }
}
