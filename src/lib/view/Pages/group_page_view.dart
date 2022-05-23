import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';

import '../../model/app_state.dart';
import '../../model/entities/course.dart';
import '../../model/entities/group.dart';
import '../Widgets/group_create_form.dart';
import '../Widgets/page_title.dart';

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

  List<Widget> showMembers(){
    var widget = <Widget>[];
    widget.add(Container(padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Members',
            style:
            Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 5),
          ),
        ],
      ),
    )
    );
    widget.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:<Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(shortName(group.manager),style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(group.manager.email,style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
              ),
            ]
        )
    );
    for (var member in group.members){
      widget.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(4.0),
              child: Text(shortName(member),style: TextStyle(fontSize:15),),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(4.0),
              child: Text(member.email,style: TextStyle(fontSize:15),),
            ),
          ]
      ));
    }
    return widget;
  }
  GroupPageViewState(Group group){
    this.group = group;
  }
  @override
  @override
  Widget getBody(BuildContext context) {

    var widget = <Widget>[
    Container(child: Text(this.group.name,style: TextStyle(fontSize:25,),textAlign: TextAlign.center,)),
    Container(
    padding: EdgeInsets.all(20.0),
    child: Text('Membros ' + (group.members.length+1).toString() +
    ' de ' + group.target_size.toString(),
    textAlign: TextAlign.left)),
    ];
    widget.addAll(showMembers());
    return ListView(
    padding: EdgeInsets.only(
    bottom: 20,
    ),
    children: widget);
  }

  String shortName(Profile profile) {
    List<String> names = profile.name.split(" ");
    return names[0]+" "+names[names.length-1];
  }
}
