import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlapInput extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<OverlapInput> {
  final List<String> students = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    setState(() {
      students.insert(0, nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Selecionar Estudantes'),
        ),
        body: Column(children: <Widget>[
          Flexible(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Up do estudante',
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {},
                    child: const Text('Adicionar'),
                  ),
                  /* TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Up do estudante',
                    ),
                  ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    addItemToList();
                  },
                ),
                */
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
                      child: Center(
                          child: Text(
                        '${students[index]}',
                        style: TextStyle(fontSize: 18),
                      )),
                    );
                  }))
        ]));
  }
}
