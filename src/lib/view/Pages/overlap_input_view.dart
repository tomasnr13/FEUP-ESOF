import 'package:flutter/material.dart';

class OverlapInput extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<OverlapInput> {
  final List<String> students = <String>[];
  bool validate = false;

  TextEditingController upController = TextEditingController();

  void addItemToList() {
    setState(() {
      validateUpCode(upController.text);
      if (validate) students.insert(0, upController.text);
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
    // check if it has the correct format
    validate = true;
    if (upCode.length == 11) {
      if (upCode.substring(0, 2).toLowerCase() != 'up' ||
          !isNumeric(upCode.substring(2))) {
        validate = false;
      }
    }
    else if (upCode.length == 9) {
      if(!isNumeric(upCode)){
        validate = false;
      }
    }
    else {
      validate = false;
    }
  }

  void removeItemFromList(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Selecionar Estudantes'),
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
                        errorText:
                        !validate ? 'Código de estudante inválido' : null,
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
                        labelText: 'Up do estudante',
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
                  padding: const EdgeInsets.all(8),
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      color: Colors.grey,
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
                  }))
        ]));
  }
}
