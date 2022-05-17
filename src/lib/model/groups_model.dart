import 'dart:ffi';

import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/schedule_page_view.dart';
import 'package:uni/view/Pages/groups_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import 'entities/course.dart';
import 'entities/groups.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  final int weekDay = DateTime.now().weekday;

  TabController tabController;
  ScrollController scrollViewController;
  List<String> studentCourses;

  List<String> daysOfTheWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  List<String> _studentCourses() {
    final courses = StoreProvider.of<AppState>(context)
        .state
        .content['schedule'];
        // .schedule;
    final list = <String>[];
    for (int j = 0; j < courses.length; j++) {
      if(!list.contains(courses[j].subject)){
        list.add(courses[j].subject);
      }
    }
    // print("list: ");
    // print(list);
    return list;
  }

  List<List<Groups>> _groupLecturesByDay(group_data) {

    // print("HERE HERE HERE");
    // print(group_data[0]);
    final aggLectures = <List<Groups>>[];
    final list_of_lectures = _studentCourses();

    for (int i = 0; i < list_of_lectures.length; i++) {
      final List<Groups> group_list = <Groups>[];
      for (int j = 0; j < group_data.length; j++) {
        if (group_data[j].course == list_of_lectures[i]) group_list.add(group_data[j]);
      }
      aggLectures.add(group_list);
    }
    return aggLectures;
  }

  @override
  TabController initState() {
    super.initState();
    tabController = TabController(vsync: this, length:4);
    final offset = 0;
    //final offset = (weekDay > 5) ? 0 : (weekDay - 1) % studentCourses.length;
    tabController.animateTo((tabController.index + offset));
    return tabController;
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>>(
      converter: (store) => Tuple2(store.state.content['schedule'],
          store.state.content['scheduleStatus']),
      builder: (context, lectureData) {
        final lectures = lectureData.item1;
        final scheduleStatus = lectureData.item2;
        final group_data = <Groups>[];
        group_data.add(Groups(id: 12, course: "CPD", target_size: 5, manager: null, members: [], closed: false));
        return GroupsPageView(
            studentCourses: _studentCourses(),
            tabController: tabController,
            scrollViewController: scrollViewController,
            daysOfTheWeek: daysOfTheWeek,
            aggLectures: _groupLecturesByDay(group_data),
            scheduleStatus: scheduleStatus);
      },
    );
  }
}
