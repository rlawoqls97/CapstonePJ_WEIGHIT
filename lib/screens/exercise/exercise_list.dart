import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighit/models/user_info.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int setNo = 5;
  @override
  Widget build(BuildContext context) {
    // final userExercise = Provider.of<List<UserExercise>>(context) ?? [];
    final size = MediaQuery.of(context).size;

    final userExercise = [1, 2];
    return ListView.builder(
      itemCount: userExercise.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              width: double.infinity,
              height: size.height * 0.09,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '딥스',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Container(
                      width: size.width * 0.34,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  setNo--;
                                });
                              },
                            ),
                            Text(
                              '$setNo set',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  setNo++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        );
      },
    );
  }
}
