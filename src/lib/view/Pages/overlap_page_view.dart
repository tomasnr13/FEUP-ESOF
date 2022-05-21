import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/free_time_slot.dart';

/// Manages the 'schedule' sections of the app
class OverlapPageView extends StatelessWidget {
  OverlapPageView(
      {Key key,
      @required this.tabController,
      @required this.daysOfTheWeek,
      @required this.commonTimeSpaces,
      @required this.scheduleStatus,//??
      this.scrollViewController});

  final List<String> daysOfTheWeek;
  final List<List<List<String>>> commonTimeSpaces;//PAIRS
  final RequestStatus scheduleStatus;
  final TabController tabController;
  final ScrollController scrollViewController;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: 'Sobreposição de Horários'),
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
        children: createSchedule(context),
      ))
    ]);
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(queryData, BuildContext context) {
    final List<Widget> tabs = <Widget>[];
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(Container(
        color: Theme.of(context).backgroundColor,
        width: queryData.size.width * 1 / 3,
        child: Tab(key: Key('schedule-page-tab-$i'), text: daysOfTheWeek[i]),
      ));
    }
    return tabs;
  }

  List<Widget> createSchedule(context) {
    final List<Widget> tabBarViewContent = <Widget>[];
    for (int i = 0; i < daysOfTheWeek.length; i++) {
      tabBarViewContent.add(createScheduleByDay(context, i));
    }
    return tabBarViewContent;
  }

  /// Returns a list of widgets for the rows with a singular class info.
  List<Widget> createScheduleRows(timespaces_day, BuildContext context) {
    final List<Widget> scheduleContent = <Widget>[];
    for (int i = 0; i < timespaces_day.length; i++) {
      final List<String> timespace = timespaces_day[i];
      scheduleContent.add(FreeTimeSlot(//CHANGE
        begin: timespace[0],
        end: timespace[1],
      ));
    }
    return scheduleContent;
  }

  Widget Function(dynamic daycontent, BuildContext context) dayColumnBuilder(
      int day) {
    Widget createDayColumn(dayContent, BuildContext context) {
      return Container(
          key: Key('schedule-page-day-column-$day'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: createScheduleRows(dayContent, context),
          ));
    }

    return createDayColumn;
  }

  Widget createScheduleByDay(BuildContext context, int day) {
    /*
    return RequestDependentWidgetBuilder(
      context: context,
      status: scheduleStatus,
      contentGenerator: dayColumnBuilder(day),
      content: commonTimeSpaces[day],
      contentChecker: commonTimeSpaces[day].isNotEmpty,
      onNullContent:
          Center(child: Text('Não existem espaços disponíveis à ' + daysOfTheWeek[day] + '.')),
      index: day,
    );
    */
    return Scaffold(
      appBar: AppBar(
          title:Text("Text Widget Example")
      ),
      body: Center(
          child:Text("Welcome to Javatpoint")
      ),
    );
  }
}
