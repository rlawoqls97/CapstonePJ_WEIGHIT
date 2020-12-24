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
                      width: size.width * 0.27,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  setNo--;
                                });
                              },
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Text(
                              '$setNo set',
                              style: TextStyle(fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  setNo++;
                                });
                              },
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w400),
                              ),
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
