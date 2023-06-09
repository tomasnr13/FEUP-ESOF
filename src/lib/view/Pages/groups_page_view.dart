import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/group_create_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';

import '../../model/entities/group.dart';
import '../Widgets/groups_slot.dart';
import 'groups_search_page_view.dart';

/// Manages the 'groups' sections of the app
class GroupsPageView extends StatelessWidget {

  GroupsPageView(
      {Key key,
      @required this.tabController,
      @required this.studentCourses,
      @required this.aggGroups,
      @required this.groupsStatus,
      this.scrollViewController});

  final List<List<Group>> aggGroups;
  final RequestStatus groupsStatus;
  final TabController tabController;
  final ScrollController scrollViewController;
  final List<String> studentCourses;

@override
Widget build(BuildContext context) {
  final MediaQueryData queryData = MediaQuery.of(context);

  return Column(children: <Widget>[
    ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        PageTitle(name: 'Grupos de Trabalho'),
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: createTabs(queryData, context),
        ),
      ],
    ),
    Expanded(
        child: TabBarView(
      controller: tabController,
      children: createGroups(context)
      ,
    )),
    Center(
        child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              groupCreateButton(context),
              ]))
  ]);
}

/// Returns a list of widgets empty with tabs for each day of the week.
List<Widget> createTabs(queryData, BuildContext context) {
  final List<Widget> tabs = <Widget>[];
  for (var i = 0; i < studentCourses.length; i++) {
    tabs.add(Container(
      color: Theme.of(context).backgroundColor,
      width: queryData.size.width * 1 / 3,
      child: Tab(key: Key('schedule-page-tab-$i'), text: studentCourses[i]),
    ));
  }
  return tabs;
}

List<Widget> createGroups(context) {
  final List<Widget> tabBarViewContent = <Widget>[];
  for (int i = 0; i < studentCourses.length; i++) {
    tabBarViewContent.add(SingleChildScrollView(child:createGroupsByCourse(context, i)));
  }
  return tabBarViewContent;
}

/// Returns a list of widgets for the rows with a singular class info.
List<Widget> createGroupRows(groups, BuildContext context) {
  final List<Widget> groupsContent = <Widget>[];
  for (int i = 0; i < groups.length; i++) {
    final Group group = groups[i];
    groupsContent.add(GroupsSlot(group));
  }
  return groupsContent;
}

Widget Function(dynamic daycontent, BuildContext context) courseColumnBuilder(
    int day) {
  Widget createCourseColumn(courseContent, BuildContext context) {
    return Container(
        key: Key('schedule-page-day-column-$day'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: createGroupRows(courseContent, context),
        ));
  }

  return createCourseColumn;
}

Widget createGroupsByCourse(BuildContext context, int courseIndex) {
  return RequestDependentWidgetBuilder(
    context: context,
    status: groupsStatus,
    contentGenerator: courseColumnBuilder(courseIndex),
    content: aggGroups[courseIndex],
    contentChecker: aggGroups[courseIndex].isNotEmpty,
    onNullContent:
        Center(child: Container(padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),child:Text('Não há grupos em ' + studentCourses[courseIndex] + '.'))),
    index: courseIndex,
  );
}

Widget groupCreateButton(BuildContext context) {
    return Container(
        child: ElevatedButton(
          onPressed: () {
              if (!FocusScope.of(context).hasPrimaryFocus) {
                FocusScope.of(context).unfocus();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupCreatePageView(studentCourses, tabController.index)));
          },
          key: const Key('create_group'),
          child: Text(
            'Criar Novo Grupo',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ));
  }

  Widget groupSearchButton(BuildContext context) {
    return Container(
        child: IconButton(
          onPressed: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupsSearchPageView(course: studentCourses[tabController.index], status: groupsStatus, defaultIndex: 0, scrollViewController: scrollViewController)));
          },
          icon: Icon(Icons.search),
        ));
  }
}
