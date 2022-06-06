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
        return FutureBuilder<List<List<TimeSlot>>>(
          future: compareSchedulesFreeTime(store, this.students),
          builder: (BuildContext context,
              AsyncSnapshot<List<List<TimeSlot>>> snapshot) {
            List<Widget> children;
            List<Widget> childrenScaffold;
            if (snapshot.hasData) {
              childrenScaffold = <Widget>[];
              children = <Widget>[];
              children.add(Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Compatibilidade de Horários'),
                    backgroundColor: Color(0xFF76171F),
                  ),
                  body: SingleChildScrollView(
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: childrenScaffold,
                      )))));
              List<List<TimeSlot>> times = snapshot.data;
                  childrenScaffold.add(Center(
                  child: (Padding(
                      padding: const EdgeInsets.only(
                          top: 2, right: 26, left: 26, bottom: 10),
                      child: Text('Tempos livres comuns',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight. bold,
                              color: Color(0xFF76171F),
                              decoration: TextDecoration.none))))));
              for (int i = 0; i < 5; i++) {
            childrenScaffold.add(Text(' ',
                    style: TextStyle(decoration: TextDecoration.none)));
            childrenScaffold.add(Text(daysOfTheWeek[i],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.none)));
                for (TimeSlot timeSlot in times[i]) {
                  final String text =
                      timeSlot.startTime + ' - ' + timeSlot.endTime;
            childrenScaffold.add(Text(text,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.none)));
                }
              }
            childrenScaffold.add(Center(
                  child: (Padding(
                      padding: const EdgeInsets.only(
                          top: 70, right: 60, left: 60, bottom: 20),
                      child: Text("Têm uma \ncompatibilidade de",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Colors.black,
                              decoration: TextDecoration.none))))));
            childrenScaffold.add(Text(compatibilityPercentage(times) + "%",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF76171F),
                      decoration: TextDecoration.none)));
            return children.first;
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
