import 'package:flutter/material.dart';
import 'package:uni/model/app_state.dart';

import '../../controller/schedule_comparison.dart';
import '../../model/entities/time_slot.dart';
import '../../model/app_state.dart';
import 'package:redux/redux.dart';

class OverlapSimple extends StatefulWidget {
  @override
  State<OverlapSimple> createState() => OverlapSimpleState();

  OverlapSimple(
      {Key key,
        @required this.store,
        @required this.students,});

  final Store<AppState> store;
  final List<String> students;
}

class OverlapSimpleState extends State<OverlapSimple> {
  final Future<List<List<TimeSlot>>> apiCall = compareSchedulesFreeTime(store, students);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<TimeSlot>>>(
        future: apiCall, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<List<TimeSlot>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 0, bottom: 5, right: 0, top: 5),
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0x94707070),
                        border: Border(
                          top: BorderSide(color: Colors.white),
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 40, bottom: 5, right: 20, top: 5),
                              //apply padding to some sides only
                              child: Center(
                                child: Text('${students[index]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, bottom: 5, right: 30, top: 5),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                onPressed: () => removeItemFromList(index),
                              ),
                            ),
                          ]),
                    );
                  }),
            ];
          } else {
            children = <Widget>[Text("All day free")];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
