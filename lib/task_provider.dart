import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly_app/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final sp = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String? tasksString = sp.getString('tasks_${user.uid}');
    if (tasksString != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksString);
      _tasks = decodedTasks.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final sp = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String encodedTasks = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await sp.setString('tasks_${user.uid}', encodedTasks);
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(Task(id: DateTime.now().toString(), title: title));
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }
}