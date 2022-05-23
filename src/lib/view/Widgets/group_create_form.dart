import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';
import 'package:sentry/sentry.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/view/Widgets/toast_message.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../model/app_state.dart';
import '../../model/entities/group.dart';

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

  void setCourses(List<String> courses, int index){
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
    for(int i = 0; i < courses.length; i++){
      courseList.add(DropdownMenuItem(child: Text(courses[i]), value: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
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
                child:
            Slider(
                activeColor: Colors.red[700],
                inactiveColor: Colors.red[300],
                min: 2,
                max: 12,
                divisions: 11,
                label: '${numberMembers.round()}',
                value: numberMembers,
                onChanged: (value){
                  setState(() {
                    numberMembers = value;
                  });
                }
            )
            )])
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
            submitBugReport();
          },
          child: Text(
            'Enviar',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ));
  }

  /// Submits the user's bug report
  ///
  /// If successful, an issue based on the bug
  /// report is created in the project repository.
  /// If unsuccessful, the user receives an error message.
  void submitBugReport() async {
    setState(() {
      _isButtonTapped = true;
    });

    final Group group = Group(id: 0, course: courses[_selectedCourse],
        name: nameController.text, target_size: numberMembers.toInt(),
        manager: StoreProvider.of<AppState>(context).state.content['profile'],
        members: [StoreProvider.of<AppState>(context).state.content['profile'],
          StoreProvider.of<AppState>(context).state.content['profile'],
          StoreProvider.of<AppState>(context).state.content['profile']],
        closed: false);
    final List<Group> newGroups = StoreProvider.of<AppState>(context).state.content['groups'];
    newGroups.add(group);
    StoreProvider.of<AppState>(context).state.cloneAndUpdateValue('groups', newGroups);
    print('Chico: ' + StoreProvider.of<AppState>(context).state.content['groups'][0].manager.name);

    clearForm();
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isButtonTapped = false;
    });
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
