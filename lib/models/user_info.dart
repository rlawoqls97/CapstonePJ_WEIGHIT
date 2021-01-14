class TheUser {
  final String uid;

  final String level;
  final String routine;
  String username;
  String weight;
  int workedDays;
  TheUser(
      {this.uid,
      this.level,
      this.routine,
      this.username,
      this.weight,
      this.workedDays});
}

class UserExercise {
  final String name;
  final String part;
  final int weight;
  final int sets;
  final int reps;

  UserExercise({this.name, this.part, this.weight, this.sets, this.reps});
}

// 만약 list int가 firebase와 호환되지 않는다면 List<dynamic>으로 교체해줄 것.
// 어차피 dynamic으로 해도 int 형태로 받아올 수 있다.
class UserRecord {
  final int level;
  final List<dynamic> shoulder;
  final List<dynamic> arm;
  final List<dynamic> chest;
  final List<dynamic> abs;
  final List<dynamic> back;
  final List<dynamic> leg;

  UserRecord(
      {this.level,
      this.shoulder,
      this.arm,
      this.chest,
      this.abs,
      this.back,
      this.leg});
}
