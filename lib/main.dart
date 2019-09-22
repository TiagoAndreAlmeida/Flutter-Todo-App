import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo",
      debugShowCheckedModeBanner: false, //hide banne debug on upper right side of screen
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage(){
    items = [];
    // items.add(Item(title: "Todo 1", done: false));
    // items.add(Item(title: "Todo 2", done: true));
    // items.add(Item(title: "Todo 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTodoCtrl = TextEditingController();

  _HomePageState () {
    load();
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  void add() {
    //valid if input text is empty
    if(newTodoCtrl.text.trim().isEmpty) return;

    setState(() {
      widget.items.add(
        Item(
          title: newTodoCtrl.text,
          done: false
        )
      );
    });
    newTodoCtrl.clear();
    save();
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
    save();
  }

  Future load () async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if(data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTodoCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            decoration: TextDecoration.none
          ),
          decoration: InputDecoration(
            labelText: "Add New Todo here...",
            labelStyle: TextStyle(
              color: Colors.white
            )
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
            direction: DismissDirection.startToEnd,
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                });
                save();
              },
            ),
            background: Container(
              color: Colors.redAccent,
              child: Icon(Icons.restore_from_trash),
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}