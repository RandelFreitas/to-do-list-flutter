import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello/src/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLASSE HOME_PAGE
class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

//CLASSE INVOCADA PELA HOME_PAGE
class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  //ADICIONA NA LIST E SALVA NO BANCO SHARED
  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(
        Item(
          title: newTaskCtrl.text,
          done: false,
        ),
      );
      newTaskCtrl.text = "";
      save();
    });
  }

  //REMOVER DA LISTA E SALVAR NO SHARED O STATE ATUAL
  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  //CARREGA DO BANCO SHARED
  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  //SALVA NO SHARED
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  //CONSTRUTOR PARA O APP INICIAR COM DADOS DO SHARED
  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.8),
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
