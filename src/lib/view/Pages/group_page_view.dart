import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

import '../../model/entities/group.dart';
import '../Widgets/groups_slot.dart';

/// Manages the 'schedule' sections of the app
class GroupPageView extends StatelessWidget {

  GroupPageView({Key key,
    @required this.group
  });

  final Group group;
  final double borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          PageTitle(name: group.name),
        ],
      ),
    ]);
  }
}