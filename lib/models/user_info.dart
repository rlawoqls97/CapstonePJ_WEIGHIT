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
