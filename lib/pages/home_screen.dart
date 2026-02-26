import 'package:flutter/material.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/utils/todo_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController newTaskController = TextEditingController();

  final _mybox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();

  @override
void initState() {
  super.initState();

  if (_mybox.get('TODOLIST') == null) {
    db.createData();
  } else {
    db.loadData();
  }
}

  // List todoList = [
  //   ['Learn Flutter', false],
  //   ['Go to GYM', false],
  // ];

  void checkboxChanged(int index) {
    db.todoList[index][1] = !db.todoList[index][1];
    setState(() {});
    db.updateDatabase();
  }

  void saveNewTask() {
    if (newTaskController.text.isEmpty) {
      return;
    }
    setState(() {
      db.todoList.add([newTaskController.text, false]);
      newTaskController.clear();
    });
    db.updateDatabase();
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return TodoList(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onChanged: (value) => checkboxChanged(index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),

      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: newTaskController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 211, 192, 250),
                  hintText: 'Add new task',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              saveNewTask();
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
