import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/exercise_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weighit/services/Exercise_database.dart';

class Chest extends StatefulWidget {
  @override
  _ChestState createState() => _ChestState();
}

class _ChestState extends State<Chest>
    with AutomaticKeepAliveClientMixin<Chest> {
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (Provider.of<List<Exercise>>(context) == null) {
      return Center(child: CircularProgressIndicator());
    }
    final exerciseList = Provider.of<List<Exercise>>(context)
            .where((element) => element.part == '가슴')
            .toList() ??
        [];
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.39,
      child: ListView(
        shrinkWrap: true,
        children:
            exerciseList.map((val) => _exerciseTile(context, val)).toList(),
      ),
    );
  }

  Widget _exerciseTile(BuildContext context, Exercise exercise) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Card(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            onTap: () async {
              await ExerciseDB(part: '가슴').updateNewExerciseData(exercise.name);
            },
            title: Text(
              exercise.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ));
  }
}
