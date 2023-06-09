import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/groups_fetcher/groups_fetcher_files.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/group.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class GroupCreateForm extends StatefulWidget {
  List<String> courses;
  int index;

  GroupCreateForm(List<String> courses, int index) {
    this.courses = courses;
    this.index = index;
  }

  @override
  State<StatefulWidget> createState() {
    return GroupCreateFormState(courses, index);
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class GroupCreateFormState extends State<GroupCreateForm> {
  static final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> courseList = [];
  List<String> courses;
  int index;

  double numberMembers = 2.0;
  static int _selectedCourse = 0;
  static final TextEditingController nameController = TextEditingController();
  String ghToken = '';

  bool _isButtonTapped = false;

  void setCourses(List<String> courses, int index) {
    this.courses = courses;
    this.index = index;
  }

  GroupCreateFormState(List<String> courses, int index) {
    setCourses(courses, index);
    //if (ghToken == '') loadGHKey();
    loadCourseList();
  }

  void loadCourseList() {
    _selectedCourse = index;
    courseList = [];
    for (int i = 0; i < courses.length; i++) {
      courseList.add(DropdownMenuItem(child: Text(courses[i]), value: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(context),
        ));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(createGroupTitle(context));
    formWidget.add(dropdownCourseSelectWidget(context));
    formWidget.add(FormTextField(
      nameController,
      Icons.create_outlined,
      minLines: 1,
      maxLines: 2,
      description: 'Nome do Grupo',
      labelText: 'Insira o nome do grupo',
      bottomMargin: 30.0,
    ));

    formWidget.add(numberElementsSliderWidget(context));

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
              'Criar Grupo de Trabalho',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            Icon(Icons.group_add,
                color: Theme.of(context).accentColor, size: 50.0),
          ],
        ));
  }

  /// Returns a widget for the dropdown displayed when the user tries to choose
  /// the type of bug on the form
  Widget dropdownCourseSelectWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cadeira',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.book,
                  color: Theme.of(context).accentColor,
                )),
            Expanded(
                child: DropdownButton(
              hint: Text('Cadeira'),
              items: courseList,
              value: _selectedCourse,
              onChanged: (value) {
                setState(() {
                  _selectedCourse = value;
                });
              },
              isExpanded: true,
            ))
          ])
        ],
      ),
    );
  }

  Widget numberElementsSliderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Número de Elementos',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.numbers,
                  color: Theme.of(context).accentColor,
                )),
            Expanded(
                child: Slider(
                    key: const Key('create_group_form_slider'),
                    activeColor: Colors.red[700],
                    inactiveColor: Colors.red[300],
                    min: 2,
                    max: 12,
                    divisions: 10,
                    label: '${numberMembers.round()}',
                    value: numberMembers,
                    onChanged: (value) {
                      setState(() {
                        numberMembers = value;
                      });
                    }))
          ])
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 50.0),
        child: ElevatedButton(
          onPressed: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
            submitGroup();
          },
          key: const Key('create_group_form_send'),
          child: Text(
            'Confirmar',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ));
  }

  /// Submits the new group
  void submitGroup() async {
    setState(() {
      _isButtonTapped = true;
    });

    final Group group = Group(
        id: 0,
        course: courses[_selectedCourse],
        name: nameController.text,
        target_size: numberMembers.round(),
        manager: StoreProvider.of<AppState>(context).state.content['profile'],
        members: []);
    final List<Group> newGroups =
        StoreProvider.of<AppState>(context).state.content['groups'];
    newGroups.add(group);
    StoreProvider.of<AppState>(context)
        .state
        .cloneAndUpdateValue('groups', newGroups);
    try {
      GroupsFetcherFiles()
          .setGroups(StoreProvider.of<AppState>(context), newGroups);
    } catch (e) {
      Logger().e('Failed to set Groups: ${e.toString()}');
    }

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
    numberMembers = 2;

    if (!mounted) return;
    setState(() {
      _selectedCourse = index;
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
