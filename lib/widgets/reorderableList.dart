import 'package:flutter/material.dart';
import 'package:weighit/models/exercise_type.dart';

class ReorderableList extends StatefulWidget {
  List<Exercise> exerciseList;

  ReorderableList({Key key, this.exerciseList}) : super(key: key);
  @override
  _ReorderableListState createState() => _ReorderableListState();
}

class _ReorderableListState extends State<ReorderableList> {
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.exerciseList.removeAt(oldindex);
      widget.exerciseList.insert(newindex, items);
    });
  }

  void sorting() {
    setState(() {
      widget.exerciseList.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: widget.exerciseList
          .map((exercise) => _exerciseTile(context, exercise))
          .toList(),
      onReorder: reorderData,
    );
  }

  Widget _exerciseTile(BuildContext context, Exercise exercise) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        key: Key(exercise.name),
        child: Card(
          elevation: 2,
          color: Theme.of(context).primaryColor,
          child: ListTile(
            onTap: () {},
            title: Text(
              exercise.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ));
  }
}
