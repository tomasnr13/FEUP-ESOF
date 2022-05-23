import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/Widgets/row_container.dart';

import '../../model/entities/group.dart';
import '../../model/entities/profile.dart';
import '../Pages/group_page_view.dart';
import '../Pages/home_page_view.dart';

class GroupsSlot extends StatelessWidget {
  Group group;

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
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createGroupsSlotPrimInfo(context),
        ));
  }

  Widget createGroupsSlotLeft(context) {
    return  Column(
      children: <Widget>[
        createGroupsRatio(context)
      ],
    );
  }

  Widget createGroupsRatio(context) => createTextField(
      (this.group.members.length + 1).toString() + '/' + this.group.target_size.toString(),
      Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
      TextAlign.center);

  List<Widget> createGroupsSlotPrimInfo(context) {
    final groupNameTextField = createTextField(
        group.name,
        Theme.of(context).textTheme.headline3.apply(fontSizeDelta: 5),
        TextAlign.center,
    );
    var icon = Icons.lock_open;
    if(this.group.closed){
      icon = Icons.lock;
    }
    final rows = [Row(children: <Widget>[groupNameTextField]), createGroupsSlotManagerRow(context)];
    for(final member in group.members){
      rows.add(createGroupsSlotMemberRow(context, member));
    }
    return [
      createGroupsSlotLeft(context),
      Column(
        children: rows,
      ),
      createGroupsLockIcon(icon)
    ];
  }

  Row createGroupsSlotManagerRow(context) {
      final widgetList = [createGroupsSlotManagerIcon(), createGroupsSlotManagerInfo(context)];
      return Row(children: widgetList);
  }

  Widget createGroupsSlotManagerInfo(context) {
    return createTextField(
        group.manager.name,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center);
  }

  Widget createGroupsSlotManagerIcon(){
    return Icon(Icons.star);
  }

  Widget createGroupsSlotMemberIcon(){
    return Icon(Icons.person);
  }

  Row createGroupsSlotMemberRow(context, member) {
    return Row(children: [createGroupsSlotMemberIcon(), createTextField(
        member.name,
        Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        TextAlign.center)]);
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget createGroupsLockIcon(icon) {
    return Icon(icon);
  }
}
