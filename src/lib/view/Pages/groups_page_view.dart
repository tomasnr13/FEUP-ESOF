import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/group_create_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

import '../../model/entities/group.dart';
import '../Widgets/groups_slot.dart';

/// Manages the 'schedule' sections of the app
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


//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryData queryData = MediaQuery.of(context);
//     // TODO: implement build
//     return Column(children: <Widget>[
//       ListView(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         children: <Widget>[
//           PageTitle(name: 'Grupos'),
//           TabBar(
//             controller: tabController,
//             isScrollable: true,
//             tabs: createTabs(queryData, context),
//           )
//         ],
//     ),
//     Expanded(
//         child: TabBarView(
//           controller: tabController,
//           children: createSchedule(context),
//         ))
//       ]);
//     throw UnimplementedError();
//   }
//
//   List<Widget> createTabs(queryData, BuildContext context) {
//       final List<Widget> tabs = <Widget>[];
//       for (var i = 0; i < studentCourses.length; i++) {
//         tabs.add(Container(
//           color: Theme.of(context).backgroundColor,
//           width: queryData.size.width * 1 / 3,
//           child: Tab(key: Key('schedule-page-tab-$i'), text: studentCourses[i]),
//         ));
//       }
//       return tabs;
//     }
//
// List<Widget> createSchedule(context) {
//   final List<Widget> tabBarViewContent = <Widget>[];
//   for (int i = 0; i < daysOfTheWeek.length; i++) {
//     tabBarViewContent.add(createScheduleByDay(context, i));
//   }
//   return tabBarViewContent;
// }
//
//   Widget createScheduleByDay(BuildContext context, int day) {
//       return RequestDependentWidgetBuilder(
//         context: context,
//         status: scheduleStatus,
//         contentGenerator: dayColumnBuilder(day),
//         content: aggLectures[day],
//         contentChecker: aggLectures[day].isNotEmpty,
//         onNullContent:
//             Center(child: Text('Não possui aulas à ' + daysOfTheWeek[day] + '.')),
//         index: day,
//       );
//     }
//
//   Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(
//     int day) {
//   Widget createDayColumn(dayContent, BuildContext context) {
//     return Container(
//         key: Key('schedule-page-day-column-$day'),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: createScheduleRows(dayContent, context),
//         ));
//   }
//
//   return createDayColumn;
// }
@override
Widget build(BuildContext context) {
  final MediaQueryData queryData = MediaQuery.of(context);

  return Column(children: <Widget>[
    ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        PageTitle(name: 'Grupos de trabalho'),
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
      children: createGroups(context),
    )),
    groupCreateButton(context)
  ]);
}

/// Returns a list of widgets empty with tabs for each day of the week.
List<Widget> createTabs(queryData, BuildContext context) {
  final List<Widget> tabs = <Widget>[];
  // print("studentCourses");
  // print(studentCourses);
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
    tabBarViewContent.add(createGroupsByCourse(context, i));
  }
  return tabBarViewContent;
}

/// Returns a list of widgets for the rows with a singular class info.
List<Widget> createGroupRows(groups, BuildContext context) {
  final List<Widget> groupsContent = <Widget>[];
  for (int i = 0; i < groups.length; i++) {
    final Group group = groups[i];
    groupsContent.add(GroupsSlot(group));
    /*
    scheduleContent.add(GroupsSlot(
      id: lecture.id,
      name: lecture.name,
      course: lecture.course,
      target_size: lecture.target_size,
      manager: lecture.manager,
      members: lecture.members,
      closed: lecture.closed,
      ));
     */
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
        Center(child: Text('Não pertence a Grupos em ' + studentCourses[courseIndex] + '.')),
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




  // @override
  // Widget build(BuildContext context) {
  //   final MediaQueryData queryData = MediaQuery.of(context);
  //
  //   return Column(children: <Widget>[
  //     ListView(
  //       scrollDirection: Axis.vertical,
  //       shrinkWrap: true,
  //       children: <Widget>[
  //         PageTitle(name: 'Grupos'),
  //         TabBar(
  //           controller: tabController,
  //           isScrollable: true,
  //           tabs: createTabs(queryData, context),
  //         ),
  //       ],
  //     ),
  //     Expanded(
  //         child: TabBarView(
  //       controller: tabController,
  //       children: createSchedule(context),
  //     ))
  //   ]);
  // }
  //
  // /// Returns a list of widgets empty with tabs for each day of the week.
  // List<Widget> createTabs(queryData, BuildContext context) {
  //   final List<Widget> tabs = <Widget>[];
  //   for (var i = 0; i < daysOfTheWeek.length; i++) {
  //     tabs.add(Container(
  //       color: Theme.of(context).backgroundColor,
  //       width: queryData.size.width * 1 / 3,
  //       child: Tab(key: Key('schedule-page-tab-$i'), text: daysOfTheWeek[i]),
  //     ));
  //   }
  //   return tabs;
  // }
  //
  // List<Widget> createSchedule(context) {
  //   final List<Widget> tabBarViewContent = <Widget>[];
  //   for (int i = 0; i < daysOfTheWeek.length; i++) {
  //     tabBarViewContent.add(createScheduleByDay(context, i));
  //   }
  //   return tabBarViewContent;
  // }
  //
  // /// Returns a list of widgets for the rows with a singular class info.
  // List<Widget> createScheduleRows(lectures, BuildContext context) {
  //   final List<Widget> scheduleContent = <Widget>[];
  //   for (int i = 0; i < lectures.length; i++) {
  //     final Lecture lecture = lectures[i];
  //     scheduleContent.add(ScheduleSlot(
  //       subject: lecture.subject,
  //       typeClass: lecture.typeClass,
  //       rooms: lecture.room,
  //       begin: lecture.startTime,
  //       end: lecture.endTime,
  //       teacher: lecture.teacher,
  //       classNumber: lecture.classNumber,
  //     ));
  //   }
  //   return scheduleContent;
  // }
  //
  // Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(
  //     int day) {
  //   Widget as
//   (dayContent, BuildContext context) {
  //     return Container(
  //         key: Key('schedule-page-day-column-$day'),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: createScheduleRows(dayContent, context),
  //         ));
  //   }
  //
  //   return createDayColumn;
  // }
  //
  // Widget createScheduleByDay(BuildContext context, int day) {
  //   return RequestDependentWidgetBuilder(
  //     context: context,
  //     status: scheduleStatus,
  //     contentGenerator: dayColumnBuilder(day),
  //     content: aggLectures[day],
  //     contentChecker: aggLectures[day].isNotEmpty,
  //     onNullContent:
  //         Center(child: Text('Não possui aulas à ' + daysOfTheWeek[day] + '.')),
  //     index: day,
  //   );
  // }
}
