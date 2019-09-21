import 'package:flutter/material.dart';

import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo",
      debugShowCheckedModeBanner: false,
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
    items.add(Item(title: "Todo 1", done: false));
    items.add(Item(title: "Todo 2", done: true));
    items.add(Item(title: "Todo 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTodoCtrl = TextEditingController();

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
          return CheckboxListTile(
            key: Key(item.title),
            title: Text(item.title),
            value: item.done,
            onChanged: (value) {
              setState(() {
                item.done = value;
              });
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
  }
}