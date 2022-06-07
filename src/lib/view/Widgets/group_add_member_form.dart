import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/groups_fetcher/groups_fetcher_files.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/utils/constants.dart' as Constants;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../model/app_state.dart';
import '../../model/entities/group.dart';
import '../../model/entities/profile.dart';

class GroupAddMemberForm extends StatefulWidget {
  Group group;

  GroupAddMemberForm(Group group) {
    this.group = group;
  }

  @override
  State<StatefulWidget> createState() {
    return GroupAddMemberFormState(group);
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class GroupAddMemberFormState extends State<GroupAddMemberForm> {
  static final _formKey = GlobalKey<FormState>();
  Group group;

  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController emailController = TextEditingController();
  String ghToken = '';

  bool _isButtonTapped = false;

  GroupAddMemberFormState(Group group) {
    this.group = group;
    //if (ghToken == '') loadGHKey();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(createGroupTitle(context));
    formWidget.add(FormTextField(
      nameController,
      Icons.person,
      minLines: 1,
      maxLines: 2,
      description: 'Nome',
      labelText: 'Insira o nome do novo membro',
      bottomMargin: 30.0,
    ));
    formWidget.add(FormTextField(
      emailController,
      Icons.alternate_email,
      minLines: 1,
      maxLines: 2,
      description: 'Email',
      labelText: 'Insira o email do novo Membro',
      bottomMargin: 30.0,
    ));

    /*
    formWidget.add(Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Slider(
        activeColor: Colors.red[700],
        inactiveColor: Colors.red[300],
        min: 2,
        max: 20,
        divisions: 19,
        label: '${numberMembers.round()}',
        value: numberMembers,
        onChanged: (value){
          setState(() {
            numberMembers = value;
          });
        }
    )));
    */

    formWidget.add(submitButton(context));

    return formWidget;
  }

  /// Returns a widget for the title of the bug report form
  Widget createGroupTitle(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(Icons.group_add,
                color: Theme.of(context).accentColor, size: 50.0),
            Expanded(
                child: Text(
              "Adicionar membro ao Grupo '" + group.name + "'",
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            Icon(Icons.group_add,
                color: Theme.of(context).accentColor, size: 50.0),
          ],
        ));
  }

  Widget submitButton(BuildContext context) {
    return Container(
        key: Key('add-member-form-add'),
        margin: EdgeInsets.symmetric(vertical: 50.0),
        child: ElevatedButton(
          onPressed: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
            submitMember();
          },
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ));
  }

  /// Submits the user's bug report
  ///
  /// If successful, an issue based on the bug
  /// report is created in the project repository.
  /// If unsuccessful, the user receives an error message.
  void submitMember() async {
    setState(() {
      _isButtonTapped = true;
    });

    final List<Group> newGroups =
        StoreProvider.of<AppState>(context).state.content['groups'];
    for (Group group in newGroups) {
      if (group == this.group) {
        group.members.add(new Profile(
            name: nameController.text, email: emailController.text));
        if (group.members.length >= group.target_size - 1) {
          group.closed = true;
        }
      }
    }
    StoreProvider.of<AppState>(context)
        .state
        .cloneAndUpdateValue('groups', newGroups);
    GroupsFetcherFiles()
        .setGroups(StoreProvider.of<AppState>(context), newGroups);
    clearForm();
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isButtonTapped = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/' + Constants.navGroups);
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();

    // numberMembers = 2;

    if (!mounted) return;
    setState(() {
      // _selectedCourse = index;
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void loadGHKey() async {
    final Map<String, dynamic> dataMap =
        await parseJsonFromAssets('assets/env/env.json');
    this.ghToken = dataMap['gh_token'];
  }
}
