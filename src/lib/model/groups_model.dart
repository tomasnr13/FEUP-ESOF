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
import 'entities/group.dart';
import 'entities/profile.dart';

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

  List<List<Group>> _groupGroupsByCourse(group_data) {

    // print("HERE HERE HERE");
    // print(group_data[0]);
    final aggGroups = <List<Group>>[];
    final list_of_courses = _studentCourses();

    for (int i = 0; i < list_of_courses.length; i++) {
      final List<Group> group_list = <Group>[];
      for (int j = 0; j < group_data.length; j++) {
        if (group_data[j].course == list_of_courses[i]) group_list.add(group_data[j]);
      }
      aggGroups.add(group_list);
    }
    return aggGroups;
  }

  @override
  TabController initState() {
    super.initState();
    tabController = TabController(vsync: this, length:4);
    final offset = 0;
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
    List<Group> groups = StoreProvider.of<AppState>(context).state.content['groups'];
    groups.clear();
    List<Profile> profiles = <Profile>[new Profile(name: "Sérgio", email: "sergio@edu.fe.up.pt"),
      new Profile(name: "António", email: "to@edu.fe.up.pt"),
      new Profile(name: "Zé", email: "ze@edu.fe.up.pt"),
      new Profile(name: "Maria", email: "maria@edu.fe.up.pt")];
    groups.add(new Group(id:0,course: "CPD", name: "grupo dos amiguinhos", target_size: 5,
        manager: profiles[0], members: [profiles[2],profiles[1],StoreProvider.of<AppState>(context).state.content['profile']],
        closed: false));
    groups.add(new Group(id:0,course: "C", name: "lol", target_size: 5,
        manager: StoreProvider.of<AppState>(context).state.content['profile'], members: [profiles[2],profiles[1]],
        closed: false));
    print(groups);
    // StoreProvider.of<AppState>(context).state.cloneAndUpdateValue('groups', groups);
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>>(
      converter: (store) => Tuple2(store.state.content['schedule'],
          store.state.content['scheduleStatus']),
      builder: (context, groupData) {
        final groupsStatus = groupData.item2;
        //final group_data = <Group>[];
        //group_data.add(Group(id: 12, course: "CPD", name: "Terrific Trio", target_size: 5, manager: null, members: [], closed: false));
        return GroupsPageView(
            studentCourses: _studentCourses(),
            tabController: tabController,
            scrollViewController: scrollViewController,
            aggGroups: _groupGroupsByCourse(StoreProvider.of<AppState>(context).state.content['groups']),
            groupsStatus: groupsStatus);
      },
    );
  }
}
