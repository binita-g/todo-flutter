import 'package:flutter/material.dart';
import 'dart:developer';
 
void main() => runApp(new TodoDemoListApp());
 
// Every component in Flutter is a widget, even the whole app itself
class TodoDemoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
 
        title: 'To-do List Demo',
        home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoDemoListState();
}

class TodoDemoListState extends State<TodoList> {
  List<String> todoItemsArrayList = [];
 
  void TodoItemListAdd(String task) {
    // Only add the task if the user actually entered something
    if(task.length > 0) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => todoItemsArrayList.add(task));
    }
  }
 
  void deleteTodoListItem(int index) {
    setState(() => todoItemsArrayList.removeAt(index));
  }
 
  void onTapDeleteTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('List item "${todoItemsArrayList[index]}" is completed?'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('CANCEL'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()
                ),
                new TextButton(
                    child: new Text('COMPLETED'),
                    onPressed: () {
                      deleteTodoListItem(index);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }
 
  // Build the whole list of todo items
  Widget AppBarBuildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        print('index: $index');
        print('todoItemsArrayListLength: ${todoItemsArrayList.length}');
        if(index < todoItemsArrayList.length) {
          return buildSingleTodoItem(todoItemsArrayList[index], index);
        } else {
          return Text("");
        }
      },
    );
  }
 
  // Build a single todo item
  Widget buildSingleTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText),
        onTap: () => onTapDeleteTodoItem(index)
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Todo List')
      ),
      body: AppBarBuildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: newAddTodoScreen,
          tooltip: 'Do Add task',
          child: new Icon(Icons.add)
      ),
    );
  }
 
  void newAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text('Add a new task')
                  ),
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      TodoItemListAdd(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'Enter task to do...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                  )
              );
            }
        )
    );
  }
}