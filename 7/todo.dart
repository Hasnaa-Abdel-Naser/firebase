import 'package:flutter/cupertino.dart';
import 'package:statemanagementtest/task.dart';

class Todo extends ChangeNotifier {
  List<Task> tasks = [];

  addTaskToList(String title,String details) {
    Task t = Task(title, details);
    tasks.add(t);
    notifyListeners(); // Notify UI (Widget)
  }
}
