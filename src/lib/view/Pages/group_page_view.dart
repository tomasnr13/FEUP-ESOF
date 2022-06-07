import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/groups_fetcher/groups_fetcher_files.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/view/Pages/group_create_add_member_view.dart';
import 'package:uni/view/Pages/invite_input_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/model/entities/group.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/utils/constants.dart' as Constants;

class GroupPageView extends StatefulWidget {
  Group group;

  GroupPageView(Group group) {
    this.group = group;
  }

  @override
  State<StatefulWidget> createState() {
    final state = GroupPageViewState(group);
    return state;
  }
}

class GroupPageViewState extends UnnamedPageView {
  Group group;

  List<Widget> showMembers() {
    var widget = <Widget>[];
    widget.add(Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Membros',
            style:
                Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 5),
          ),
        ],
      ),
    ));
    widget.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            child: Text(
              shortName(group.manager),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            child: Text(
              group.manager.email,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ]));
    if (group.manager.name ==
        StoreProvider.of<AppState>(context).state.content['profile'].name) {
      for (var member in group.members) {
        widget.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  shortName(member),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(8.0, 2.0, 4.0, 2.0),
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        member.email,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(8.0, 2.0, 4.0, 2.0),
                        padding: EdgeInsets.all(4.0),
                        child: IconButton(
                          onPressed: () {
                            if (!FocusScope.of(context).hasPrimaryFocus) {
                              FocusScope.of(context).unfocus();
                            }
                            final List<Group> newGroups =
                                StoreProvider.of<AppState>(context)
                                    .state
                                    .content['groups'];
                            for (Group group in newGroups) {
                              if (group == this.group) {
                                group.members.remove(member);
                                group.closed = false;
                                setState(() {});
                              }
                            }
                            StoreProvider.of<AppState>(context)
                                .state
                                .cloneAndUpdateValue('groups', newGroups);
                            GroupsFetcherFiles().setGroups(
                                StoreProvider.of<AppState>(context), newGroups);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/' + Constants.navGroups);
                          },
                          icon: Icon(Icons.close),
                        )),
                  ])
            ]));
      }
    } else {
      for (var member in group.members) {
        widget.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  shortName(member),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(4.0),
                child: Text(
                  member.email,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ]));
      }
    }
    return widget;
  }

  GroupPageViewState(Group group) {
    this.group = group;
  }

  @override
  @override
  Widget getBody(BuildContext context) {
    var widget = <Widget>[
      Container(
          margin: EdgeInsets.all(2.0),
          padding: EdgeInsets.all(2.0),
          child: Text(
            this.group.course,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
      Container(
          margin: EdgeInsets.all(2.0),
          padding: EdgeInsets.all(2.0),
          child: Text(
            this.group.name,
            style: TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          )),
      Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
              'Membros ' +
                  (group.members.length + 1).toString() +
                  ' de ' +
                  group.target_size.toString(),
              textAlign: TextAlign.left)),
    ];

    widget.addAll(showMembers());

    if (group.manager.name ==
        StoreProvider.of<AppState>(context).state.content['profile'].name) {
      if (group.members.length >= group.target_size - 1) {
        widget.add(
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
              child: Text("O grupo atingiu a sua capacidade máxima",
                  textAlign: TextAlign.center)),
        );
        widget.add(Container(child: Icon(Icons.lock)));
      } else {
        widget.add(
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
              child: Text('Pode adicionar mais membros ao grupo',
                  textAlign: TextAlign.center)),
        );
        widget.add(Container(child: Icon(Icons.lock_open)));

        widget.add(Container(
            margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: ElevatedButton(
                key: Key('add_member'),
                onPressed: () {
                  if (!FocusScope.of(context).hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GroupCreateAddMemberView(this.group)));
                },
                child: Text('Adicionar Membro',
                    style: TextStyle(color: Colors.white, fontSize: 20.0)))));

        widget.add(Container(
            margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
            padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: ElevatedButton(
                onPressed: () {
                  if (!FocusScope.of(context).hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InviteInput()));
                },
                child: Text('Convidar Membro',
                    style: TextStyle(color: Colors.white, fontSize: 20.0)))));
      }
      widget.add(Container(
          key: Key('remove_group'),
          margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
          padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
          child: ElevatedButton(
              onPressed: () {
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                final List<Group> newGroups =
                    StoreProvider.of<AppState>(context).state.content['groups'];
                newGroups.remove(this.group);
                StoreProvider.of<AppState>(context)
                    .state
                    .cloneAndUpdateValue('groups', newGroups);
                GroupsFetcherFiles()
                    .setGroups(StoreProvider.of<AppState>(context), newGroups);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/' + Constants.navGroups);
              },
              child: Text('Eliminar Grupo',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)))));
    } else {
      widget.add(Container(
          margin: EdgeInsets.fromLTRB(8.0, 8, 8, 0.0),
          padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
          child: ElevatedButton(
              onPressed: () {
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                final List<Group> newGroups =
                    StoreProvider.of<AppState>(context).state.content['groups'];
                for (Group group in newGroups) {
                  if (group.name == this.group.name) {
                    group.members.remove(StoreProvider.of<AppState>(context)
                        .state
                        .content['profile']);
                  }
                }
                StoreProvider.of<AppState>(context)
                    .state
                    .cloneAndUpdateValue('groups', newGroups);
                GroupsFetcherFiles()
                    .setGroups(StoreProvider.of<AppState>(context), newGroups);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/' + Constants.navGroups);
              },
              child: Text('Sair do Grupo',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)))));
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
    return names[0] + " " + names[names.length - 1];
  }
}
