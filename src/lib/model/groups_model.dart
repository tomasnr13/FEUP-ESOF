import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/groups_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/model/entities/group.dart';

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
    return list;
  }

  List<List<Group>> _groupGroupsByCourse(group_data) {
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

    // StoreProvider.of<AppState>(context).state.cloneAndUpdateValue('groups', groups);
    return StoreConnector<AppState, Tuple2<List<Group>, RequestStatus>>(
      converter: (store) => Tuple2(store.state.content['groups'],
          store.state.content['groupsStatus']),
      builder: (context, groupData) {
        final groups = groupData.item1;
        final groupsStatus = groupData.item2;
        //group_data.add(Group(id: 12, course: "CPD", name: "Terrific Trio", target_size: 5, manager: null, members: [], closed: false));
        return GroupsPageView(
            studentCourses: _studentCourses(),
            tabController: tabController,
            scrollViewController: scrollViewController,
            aggGroups: _groupGroupsByCourse(groups),
            groupsStatus: groupsStatus);
      },
    );
  }
}
