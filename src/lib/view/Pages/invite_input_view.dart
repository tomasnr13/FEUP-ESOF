import 'package:flutter/material.dart';
import 'package:uni/controller/schedule_comparison.dart';
import 'package:uni/model/overlap_page_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller/schedule_fetcher/schedule_fetcher_api.dart';

class InviteInput extends StatefulWidget {
  InviteInput(this.course, this.name);

  final String course;
  final String name;

  @override
  InviteInputState createState() => InviteInputState();
}

class InviteInputState extends State<InviteInput> {
  final List<String> students = <String>[];
  bool validate = false;
  ScheduleFetcherApi scheduleFetcherApi;

  TextEditingController upController = TextEditingController();

  void addItemToList() {
    setState(() {
      validateUpCode(upController.text);
      String upInsert = 'up';
      if (upController.text.length == 11) {
        upInsert += upController.text.substring(2);
      } else {
        upInsert += upController.text;
      }
      if (validate) students.insert(0, upInsert);
    });
  }

  void removeItemFromList(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  // preliminary check that prevents overload of request for bad input
  void validateUpCode(String upCode) {
    validate = true;

    // check if it has the correct format
    if (upCode.length == 11) {
      if (upCode.substring(0, 2).toLowerCase() != 'up' ||
          !isNumeric(upCode.substring(2))) {
        validate = false;
      }

      // check if it has already been submitted
      if (students.contains(upCode) || students.contains(upCode.substring(2))) {
        validate = false;
      }
    } else if (upCode.length == 9) {
      if (!isNumeric(upCode)) {
        validate = false;
      }

      // check if it has already been submitted
      if (students.contains(upCode) || students.contains('up' + upCode)) {
        validate = false;
      }
    } else {
      validate = false;
    }
  }

  void goToComparisonView() {
    // check whether there are 2 or more students submitted
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seleciona pelo menos 1 estudante'),
        ),
      );
      return;
    }

    // go to next page and makes api call
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OverlapPage(students: students)),
    );
  }

  Future launchEmail() async {
    String emailString = '@up.pt';
    String toEmail = "";

    for (var up in students) {
      if (!up.startsWith('u')) {
        toEmail += 'up';
      }

      toEmail += up + emailString;
      toEmail += ',';
    }

    String pluralS = '';
    String pluralM = '';
    if (students.length > 1) {
      pluralS = 's';
      pluralM = 'm';
    }

    toEmail = toEmail.substring(0, toEmail.length - 1);

    String subject = 'Convite para grupo de ${widget.course}';
    String message =
        'Caro$pluralS/a$pluralS colega$pluralS, \r\n\r\nGostava de o$pluralS/a$pluralS convidar para participar no meu grupo de trabalho de ${widget.course}. \r\nPor favor, envie$pluralM um email a confirmar. \r\n\r\nCumprimentos, \r\n${widget.name}';

    final String url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Convidar Estudantes'),
          backgroundColor: Color(0xFF76171F),
        ),
        body: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      cursorColor: Color(0xFF76171F),
                      controller: upController,
                      decoration: InputDecoration(
                        errorText: !validate
                            ? 'Código inválido ou já submetido'
                            : null,
                        floatingLabelStyle:
                            TextStyle(fontSize: 20.0, color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF76171F), width: 2.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 25.0,
                          color: Color(0xFF76171F),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Código do estudante',
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: addItemToList,
                    child: const Text('Adicionar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                ]),
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 0, bottom: 5, right: 0, top: 5),
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0x94707070),
                        border: Border(
                          top: BorderSide(color: Colors.white),
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 40, bottom: 5, right: 20, top: 5),
                              //apply padding to some sides only
                              child: Center(
                                child: Text('${students[index]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, bottom: 5, right: 30, top: 5),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                onPressed: () => removeItemFromList(index),
                              ),
                            ),
                          ]),
                    );
                  })),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 15, right: 20, top: 15),
            //apply padding to some sides only
            child: Center(
              child: Text('${students.length} selecionados',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  )),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF76171F),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () => launchEmail(),
            // TODO: go to next page after calling for schedules comparison function
            child: const Text(
              'Enviar convite(s)',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ]));
  }
}
