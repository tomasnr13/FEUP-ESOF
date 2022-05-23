import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/Widgets/row_container.dart';

import '../../model/entities/group.dart';
import '../../model/entities/profile.dart';
import '../Pages/group_page_view.dart';
import '../Pages/home_page_view.dart';

class GroupsSlot extends StatelessWidget {
  Group group;
  /*
  final int id;
  final String course;
  final String name;
  final int target_size;
  final Profile manager;
  bool closed;
  List<Profile> members;

  GroupsSlot({
    Key key,
    @required this.id,
    @required this.name,
    @required this.course,
    @required this.target_size,
    @required this.manager,
    @required this.members,
    @required this.closed,
  }) : super(key: key);
  */
  GroupsSlot(Group group){
    this.group = group;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupPageView(group)));
        },
        child:
        RowContainer(
          child: Container(
          padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
          child: createGroupsSlotRow(context),
    ))
    );
  }

  Widget createGroupsSlotRow(context) {
    return  Container(
        key: Key('schedule-slot-time-${"var1"}-${"var2"}'),
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createGroupsSlotPrimInfo(context),
        ));
  }

  Widget createGroupsSlotTime(context) {
    return  Column(
      key: Key('schedule-slot-time-${"var3"}-${"var4"}'),
      children: <Widget>[
        createGroupsTime(group.members[0].email, context),
        createGroupsTime(group.members[1].email, context)
      ],
    );
  }

  Widget createGroupsTime(String time, context) => createTextField(
      time,
      Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
      TextAlign.center);

  List<Widget> createGroupsSlotPrimInfo(context) {
    final subjectTextField = createTextField(
        group.name,
        Theme.of(context).textTheme.headline3.apply(fontSizeDelta: 5),
        TextAlign.center);
    final roomTextField = createTextField(
        "var9",
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.right);
    return [
      createGroupsSlotTime(context),
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              subjectTextField,
            ],
          ),
          Row(
            children: [
              createGroupsSlotManagerInfo(context)
            ],
          )
        ],
      ),
      createGroupsSlotPrimInfoColumn(roomTextField)
    ];
  }

  Widget createGroupsSlotManagerInfo(context) {
    return createTextField(
        group.manager.name,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center);
  }


  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget createGroupsSlotPrimInfoColumn(elements) {
    return Container(child: elements);
  }
}
