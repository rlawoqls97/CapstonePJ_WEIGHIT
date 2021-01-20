import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighit/models/exercise_type.dart';
import 'package:weighit/models/user_info.dart';

class ExerciseDB {
  final String uid;
  final String routineName;
  ExerciseDB({this.uid, this.routineName});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference routineCollection =
      FirebaseFirestore.instance.collection('routine');
  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercise');

  // 새로운 루틴의 이름을 업데이트 할 때
  Future updateUserRoutineData() async {
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .set({'routineName': routineName});
  }

  //유저마다 가지고 있는 routine->uid->userRoutines->routineName->userExercise에 새로운
  //운동을 추가하는 행위. update와 다른점: weight와 reps를 int로 받아서 list로 바꿔 저장한다.
  Future addNewUserExerciseData(String exerciseName, String part, int weight,
      int sets, int reps, int index) async {
    List<dynamic> weightList = [];
    List<dynamic> repsList = [];

    for (int i = 0; i < sets; i++) {
      weightList.add(weight);
      repsList.add(reps);
    }
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('$index')
        .set({
      'name': exerciseName,
      'part': part,
      'weight': weightList,
      'sets': sets,
      'reps': repsList,
      'index': index
    });
  }

  // 이미 있는 운동 정보를 update할 때
  Future updateUserExerciseData(String exerciseName, String part,
      List<dynamic> weight, int sets, List<dynamic> reps, int index) async {
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('$index')
        .update({
      'name': exerciseName,
      'part': part,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'index': index
    });
  }

  // 수정된 set수만큼 weight와 reps도 수정해서 업데이트하기
  Future updateUserExerciseSet(UserExercise userExercise, int sets) async {
    List<dynamic> weightList = userExercise.weight;
    List<dynamic> repsList = userExercise.reps;

    if (userExercise.sets > sets) {
      weightList = userExercise.weight.sublist(0, sets);
      repsList = userExercise.reps.sublist(0, sets);
    } else {
      for (int i = 0; i < sets - userExercise.sets; i++) {
        weightList.add(userExercise.weight[userExercise.sets - 1]);
        repsList.add(userExercise.reps[userExercise.sets - 1]);
      }
    }

    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('${userExercise.index}')
        .update({
      'weight': weightList,
      'sets': sets,
      'reps': repsList,
    });
  }

  //특정 세트의 반복횟수를 바꾸면 Firebase에 update하기
  Future updateUserExerciseReps(UserExercise userExercise) async {
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('${userExercise.index}')
        .update({
      'reps': userExercise.reps,
    });
  }

  //특정 세트의 무게를 바꾸면 Firebase에 update하기
  Future updateUserExerciseWeight(UserExercise userExercise) async {
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('${userExercise.index}')
        .update({
      'weight': userExercise.weight,
    });
  }

  Future updateUserExerciseAllReps(UserExercise userExercise) async {
    List<dynamic> repsList = [];

    for (int i = 0; i < userExercise.sets; i++) {
      repsList.add(userExercise.reps[0]);
      print(repsList);
    }

    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('${userExercise.index}')
        .update({
      'reps': repsList,
    });
  }

  Future updateUserExerciseAllWeight(UserExercise userExercise) async {
    List<dynamic> weightList = [];

    for (int i = 0; i < userExercise.sets; i++) {
      weightList.add(userExercise.weight[0]);
    }
    return await routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .doc('${userExercise.index}')
        .update({
      'weight': weightList,
    });
  }

  //유저마다 가지고 있는 user collection에 있는 자신 전용 collection을 update하는 것
  //수정해야함
  // Future updateUserExerciseData(
  //     String name, String part, int weight, int sets, int reps) async {
  //   return await userCollection
  //       .doc(uid)
  //       .collection('user_defined_routines')
  //       .add({
  //     'name': name,
  //     'part': part,
  //     'weight': weight,
  //     'sets': sets,
  //     'reps': reps,
  //   });
  // }

  //전체 exercise collection update
  // index 추가 해야함
  Future updateExerciseData(String name, String part) async {
    return await exerciseCollection.add({
      'name': name,
      'part': part,
    });
  }

  // UserRoutine list from snapshot
  List<UserRoutine> _userRoutineListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserRoutine(
        routineName: doc.get('routineName'),
        // 레벨도 나중에 받기
        level: '중급',
        workoutList: ['벤치프레스', '랫 풀 다운', '런지'],
      );
    }).toList();
  }

  // UserExercise list from snapshot
  List<UserExercise> _userExerciseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserExercise(
        name: doc.get('name') ?? '',
        part: doc.get('part') ?? '',
        weight: doc.get('weight') ?? [0],
        sets: doc.get('sets') ?? 0,
        reps: doc.get('reps') ?? [0],
        index: doc.get('index'),
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

  // get UserRoutine stream
  Stream<List<UserRoutine>> get userRoutine {
    return routineCollection
        .doc(uid)
        .collection('userRoutines')
        .snapshots()
        .map(_userRoutineListFromSnapshot);
  }

  // get userExercise stream
  Stream<List<UserExercise>> get userExercise {
    return routineCollection
        .doc(uid)
        .collection('userRoutines')
        .doc(routineName)
        .collection('userExercise')
        .snapshots()
        .map(_userExerciseListFromSnapshot);
    // exerciseCollection.where('part', '==', part).get()
  }

  Stream<List<Exercise>> get exercise {
    return exerciseCollection.snapshots().map(_exerciseListFromSnapshot);
    // exerciseCollection.where('part', '==', part).get()
  }
}
