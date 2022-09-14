import 'package:flutter/material.dart';
import 'dart:developer';
 
 // Run app.
void main() => runApp(new TodoDemoListApp());
 
// Create the whole app as a stateless widget.
class TodoDemoListApp extends StatelessWidget {

  // Override the build function to call the stateful TodoList widget.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
 
        title: 'To-do List Demo',
        home: new TodoList()
    );
  }
}

// The TodoList widget must be stateful, because the todo list will be dynamically updated.
class TodoList extends StatefulWidget {
  @override
  createState() => new TodoDemoListState();
}

// The TodoDemoListState manages the list items themselves. This will keep track of when the state changes and update the list accordingly.
class TodoDemoListState extends State<TodoList> {
  // Create an array to store the tasks in.
  List<String> todoItemsArrayList = [];
 
  void TodoItemListAdd(String task) {
    // Only create a new task if the user entered something.
    if(task.length > 0) {
      // setState keeps track of whenever the state changes and then adds the task to the list.
      setState(() => todoItemsArrayList.add(task));
    }
  }
 
 // To deelete an item, remove the task of the corresponding index.
  void deleteTodoListItem(int index) {
    setState(() => todoItemsArrayList.removeAt(index));
  }
 
 // Delete the todo list item when it is clicked.
  void onTapDeleteTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              // Confirmation modal to confirm that the user truly does want to mark the item as completed.
              title: new Text('Mark item "${todoItemsArrayList[index]}" as completed?'),
              actions: <Widget>[
                // In modal, offer option to cancel the action.
                new TextButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                // In modal, offer option to complete the action and mark the item as completed.
                new TextButton(
                    child: new Text('COMPLETE'),
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
        if(index < todoItemsArrayList.length) {
          return buildSingleTodoItem(todoItemsArrayList[index], index);
        } else {
          return Text("");
        }
      },
    );
  }
 
  // Build a single task by assigning it a title and adding funcitonality for when it is clicked.
  Widget buildSingleTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText),
        onTap: () => onTapDeleteTodoItem(index)
    );
  }
 
  // Build the "scaffolding" or the layout of the app with the title bar, body, and add button
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Build the Todo List widget with the title at the top
      appBar: new AppBar(
          title: new Text('Todo List')
      ),
      // Compile the todo list in the body of the app
      body: AppBarBuildTodoList(),
      // "Add task" button in bottom right corner
      floatingActionButton: new FloatingActionButton(
          onPressed: newAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }
 
  // When "Add" button is clicked, take users to new page where they can enter the task.
  void newAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute has a text field entry to enter the task and a back button to close it.
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                // Title bar
                  appBar: new AppBar(
                      title: new Text('Add a new task')
                  ),
                  // Text field to enter the task
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      TodoItemListAdd(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        // Placeholder text to guide the user
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