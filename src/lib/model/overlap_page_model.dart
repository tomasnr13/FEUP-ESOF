import 'dart:developer';

import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/view/Pages/schedule_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import '../controller/schedule_comparison.dart';
import '../view/Pages/overlap_page_view.dart';
import '../view/Widgets/schedule_slot.dart';
import 'entities/time_slot.dart';

class OverlapPage extends StatefulWidget {
  const OverlapPage({Key key, @required this.students}) : super(key: key);

  final List<String> students;

  @override
  _OverlapPageState createState() => _OverlapPageState(this.students);
}

class _OverlapPageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  _OverlapPageState(this.students);
  final List<String> students;
  final int weekDay = DateTime.now().weekday;

  TabController tabController;
  ScrollController scrollViewController;

  final List<String> daysOfTheWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: daysOfTheWeek.length);
    final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
    tabController.animateTo((tabController.index + offset));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<List<Lecture>> _groupLecturesByDay(schedule) {
    final aggLectures = <List<Lecture>>[];

    for (int i = 0; i < daysOfTheWeek.length; i++) {
      final List<Lecture> lectures = <Lecture>[];
      for (int j = 0; j < schedule.length; j++) {
        if (schedule[j].day == i) lectures.add(schedule[j]);
      }
      aggLectures.add(lectures);
    }
    return aggLectures;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return FutureBuilder<List<Lecture>>(
          future: allSchedulesFromStudentsList(this.students, store),
          builder: (BuildContext context,
              AsyncSnapshot<List<Lecture>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              List<List<Lecture>> times = _groupLecturesByDay(snapshot.data);
              for (int i = 0; i < 5; i++) {
                children.add(Text(' ', style: TextStyle(decoration: TextDecoration.none)));
                children.add(Text(daysOfTheWeek[i], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.none)));
                for (Lecture lecture in times[i]) {
                  final String text = lecture.startTime + ' - ' + lecture.endTime;
                  children.add(Text(text, style: TextStyle(fontSize: 12, color: Colors.white, decoration: TextDecoration.none)));
                }
              }
              // return SchedulePageView(
              //     tabController: tabController,
              //     scrollViewController: scrollViewController,
              //     daysOfTheWeek: daysOfTheWeek,
              //     aggLectures: _groupLecturesByDay(snapshot.data));
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        );
      },
    );
  }
}
