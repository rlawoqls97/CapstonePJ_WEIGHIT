import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighit/models/exercise_type.dart';
import 'package:weighit/models/user_info.dart';

class ExerciseDB {
  final String uid;
  ExerciseDB({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercise');

  //유저마다 가지고 있는 user collection에 있는 자신 전용 collection을 update하는 것
  Future updateUserExerciseData(
      String name, String part, int weight, int sets, int reps) async {
    return await userCollection
        .doc(uid)
        .collection('user_defined_routines')
        .add({
      'name': name,
      'part': part,
      'weight': weight,
      'sets': sets,
      'reps': reps,
    });
  }

  //전체 exercise collection update
  Future updateExerciseData(String name, String part) async {
    return await exerciseCollection.add({
      'name': name,
      'part': part,
    });
  }

  // UserExercise list from snapshot
  List<UserExercise> _userExerciseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserExercise(
        name: doc.get('name') ?? '',
        part: doc.get('part') ?? '',
        weight: doc.get('weight') ?? '0',
        sets: doc.get('sets') ?? '0',
        reps: doc.get('reps') ?? '0',
      );
    }).toList();
  }

  // Exercise list from snapshot
  List<Exercise> _exerciseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Exercise(
        name: doc.get('name') ?? '',
        part: doc.get('part') ?? '',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<UserExercise>> get userExercise {
    return userCollection
        .doc(uid)
        .collection('user_defined_routines')
        .snapshots()
        .map(_userExerciseListFromSnapshot);
    // exerciseCollection.where('part', '==', part).get()
  }

  Stream<List<Exercise>> get exercise {
    return exerciseCollection.snapshots().map(_exerciseListFromSnapshot);
    // exerciseCollection.where('part', '==', part).get()
  }
}