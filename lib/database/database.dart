import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/utils/todo_list.dart';

class TodoDatabase {
  List todoList = [];

  final _myBox = Hive.box('mybox');

  void createData() {
    todoList = [
      ['Learn Flutter', false],
      ['Go to GYM', false],
    ];
    updateDatabase();
  }

  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

  void updateDatabase() {
    _myBox.put('TODOLIST', todoList);
  }
}
