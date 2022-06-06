import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';
import 'package:uni/view/Widgets/group_add_member_form.dart';

import '../../model/entities/course.dart';
import '../../model/entities/group.dart';
import '../Widgets/group_create_form.dart';

class GroupCreateAddMemberView extends StatefulWidget {
  Group group;
  GroupCreateAddMemberView(Group group){
    this.group = group;
  }
  @override
  State<StatefulWidget> createState(){
    final state = GroupCreateAddMemberViewState(group);
    return state;
  }
}

/// Manages the 'Bugs and sugestions' section of the app.
class GroupCreateAddMemberViewState extends UnnamedPageView {
  Group group;
  GroupCreateAddMemberViewState(Group group){
    this.group = group;
  }

  @override
  Widget getBody(BuildContext context) {
    return  Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  GroupAddMemberForm(group)
    );
  }
}