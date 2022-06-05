import 'package:flutter/gestures.dart';
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
import 'unnamed_page_view.dart';

class GroupsSearchPageView extends StatefulWidget {
  final String course;
  final RequestStatus status;
  final int defaultIndex;
  final ScrollController scrollViewController;

  GroupsSearchPageView({Key key,
    @required this.course,
    @required this.status,
    @required this.scrollViewController,
    this.defaultIndex=0});

  @override
  State<StatefulWidget> createState(){
    final state = GroupsSearchPageViewState(course: course, status: status, scrollViewController: scrollViewController, defaultIndex: defaultIndex);
    return state;
  }
}

class GroupsSearchPageViewState extends UnnamedPageView {

  GroupsSearchPageViewState(
      {Key key,
        @required this.course,
        @required this.status,
        this.defaultIndex=0,
        this.scrollViewController});

  //final TabController tabController = new TabController(length: 2, vsync: new Ticker());
  final TabController tabController = new TabController(length: 2);
  final String course;
  final RequestStatus status;
  final int defaultIndex;
  final ScrollController scrollViewController;

  final List <String> tabNames = ['Pessoas', 'Grupos'];

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: 'Pesquisa de Grupos'),
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
            children: createCards(context),
          ))
    ]);
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = <Widget>[];
    // print("studentCourses");
    // print(studentCourses);
    for (var i = 0; i < tabNames.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        width: queryData.size.width * 1 / 2,
        child: Tab(key: Key('schedule-page-tab-$i'), text: tabNames[i]),
      ));
    }
    return tabs;
  }

  List<Widget> createCards(context) {
    final List<Widget> tabBarViewContent = <Widget>[];
    for (int i = 0; i < tabNames.length; i++) {
      tabBarViewContent.add(createCardsByTab(context, i));
    }
    return tabBarViewContent;
  }

  /// Returns a list of widgets for the rows with a singular class info.
  List<Widget> createSearchRows(groups, BuildContext context) {
    final List<Widget> groupsContent = <Widget>[];
    for (int i = 0; i < groups.length; i++) {
      final Group group = groups[i];
      groupsContent.add(GroupsSlot(group));
    }
    return groupsContent;
  }

  Widget Function(dynamic daycontent, BuildContext context) searchColumnBuilder(
      int day) {
    Widget createCourseColumn(courseContent, BuildContext context) {
      return Container(
          key: Key('schedule-page-day-column-$day'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: createSearchRows(courseContent, context),
          ));
    }

    return createCourseColumn;
  }

  Widget createCardsByTab(BuildContext context, int courseIndex) {
    return RequestDependentWidgetBuilder(
      context: context,
      status: status,
      contentGenerator: searchColumnBuilder(courseIndex),
      content: tabNames[courseIndex],
      contentChecker: tabNames[courseIndex].isNotEmpty,
      onNullContent:
      Center(child: Text('Não pertence a Grupos em ' + '.')),
      index: courseIndex,
    );
  }


}
