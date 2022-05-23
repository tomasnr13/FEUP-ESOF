import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';

import '../../model/entities/course.dart';
import '../../model/entities/group.dart';
import '../Widgets/group_create_form.dart';

class GroupPageView extends StatefulWidget {
  Group group;
  GroupPageView(Group group){
    this.group = group;
  }
  @override
  State<StatefulWidget> createState(){
    final state = GroupPageViewState(group);
    return state;
  }
}

/// Manages the 'Bugs and sugestions' section of the app.
class GroupPageViewState extends UnnamedPageView {
  Group group;
  GroupPageViewState(Group group){
    this.group = group;
  }
  @override
  @override
  Widget getBody(BuildContext context) {
    return  Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  Text(group.name)
    );
  }
}
