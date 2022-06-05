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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    if (group.manager.name == StoreProvider.of<AppState>(context).state.content['profile'].name) {
      for (var member in group.members) {
        widget.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(shortName(member), style: TextStyle(fontSize: 15),),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(8.0,2.0,4.0,2.0),
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        member.email, style: TextStyle(fontSize: 15),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8.0,2.0,4.0,2.0),
                      padding: EdgeInsets.all(4.0),
                      child:
                      IconButton(
                        onPressed: () {
                        if (!FocusScope
                          .of(context)
                          .hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => null));
                        },
                      icon: Icon(Icons.close),
                      )
                    ),
                  ])
            ]
        ));
      }
    }else {
      for (var member in group.members) {
        widget.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(shortName(member), style: TextStyle(fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(4.0),
                child: Text(
                  member.email, style: TextStyle(fontSize: 15),),
              ),
            ]
        ));
      }
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
    Container(margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(2.0),
        child: Text(this.group.course,style: TextStyle(fontSize:30,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
    Container(margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(2.0),
        child: Text(this.group.name,style: TextStyle(fontSize:25,),textAlign: TextAlign.center,)),
    Container(
    padding: EdgeInsets.all(20.0),
    child: Text('Membros ' + (group.members.length+1).toString() +
    ' de ' + group.target_size.toString(),
    textAlign: TextAlign.left)),
    ];

    widget.addAll(showMembers());

    if (group.manager.name == StoreProvider.of<AppState>(context).state.content['profile'].name) {
      if(group.members.length>= group.target_size-1){
      widget.add(Container(padding: EdgeInsets.fromLTRB(20.0,40.0,20.0,20.0),
          child: Text("The group has reached it's maximum capacity",
            textAlign: TextAlign.center)),);
      widget.add(Container(child:Icon(Icons.lock)));
      }else {
      widget.add(Container(padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
          child: Text('You can still add more members',
              textAlign: TextAlign.center)),);
      widget.add(Container(child: Icon(Icons.lock_open)));

      widget.add(Container(margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
          padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
          child: ElevatedButton(
              onPressed: () {
                if (!FocusScope
                    .of(context)
                    .hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => null));
              },
              child: Text('Add Member',
                  style: TextStyle(color: Colors.white, fontSize: 20.0))
          )
      )
      );
      }
        widget.add(Container(margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: ElevatedButton(
                onPressed: () {
                  if (!FocusScope
                      .of(context)
                      .hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => null));
                },
                child: Text('Delete Group',
                    style: TextStyle(color: Colors.white, fontSize: 20.0))
            )
        )
        );
      }else {
        widget.add(Container(margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: ElevatedButton(
                onPressed: () {
                  if (!FocusScope
                      .of(context)
                      .hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => null));
                },
                child: Text('Leave Group',
                    style: TextStyle(color: Colors.white, fontSize: 20.0))
            )
        )
        );
      }
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
