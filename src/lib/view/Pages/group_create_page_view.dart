import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';

import '../../model/entities/course.dart';
import '../Widgets/group_create_form.dart';

class GroupCreatePageView extends StatefulWidget {
  List<String> courses;
  int index;
  GroupCreatePageView(List<String> courses, int index){
    this.courses = courses;
    this.index = index;
  }
  @override
  State<StatefulWidget> createState(){
    final state = GroupCreatePageViewState(courses, index);
    return state;
  }
}

/// Manages the 'Bugs and sugestions' section of the app.
class GroupCreatePageViewState extends UnnamedPageView {
  List<String> courses;
  int index;
  GroupCreatePageViewState(List<String> courses, int index){
    this.courses = courses;
    this.index = index;
  }

  @override
  Widget getBody(BuildContext context) {
    return  Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  GroupCreateForm(courses, index)
    );
  }
}