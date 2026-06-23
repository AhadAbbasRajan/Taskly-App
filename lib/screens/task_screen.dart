import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../task.dart';
import 'login_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _currentUsername = "";

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final sp = await SharedPreferences.getInstance();
    _currentUsername = sp.getString('currentUser') ?? "";
    final String? tasksString = sp.getString('tasks_$_currentUsername');

    if (tasksString != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksString);
      setState(() {
        _tasks = decodedTasks.map((item) => Task.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final sp = await SharedPreferences.getInstance();
    final String encodedTasks = jsonEncode(
      _tasks.map((t) => t.toJson()).toList(),
    );
    await sp.setString('tasks_$_currentUsername', encodedTasks);
  }

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;

    setState(() {
      _tasks.add(
        Task(id: DateTime.now().toString(), title: _taskController.text.trim()),
      );
    });

    _taskController.clear();
    _saveTasks();
    Navigator.pop(context);
  }

  void _toggleTaskCompletion(int index) {
    setState(() => _tasks[index].isCompleted = !_tasks[index].isCompleted);
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
    _saveTasks();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('currentUser'); // Clear active user session

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add New Task",
            style: TextStyle(color: Color(0xff203142)),
          ),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: "What do you need to do?",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xff4C5980)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF9703B),
              ),
              onPressed: _addTask,
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Tasks",
              style: TextStyle(
                color: Color(0xff203142),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              _currentUsername,
              style: const TextStyle(color: Color(0xffF9703B), fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xffF9703B)),
            onPressed: _logout,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet. Tap + to add one!",
                style: TextStyle(color: Color(0xff4C5980)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xffE4E7EB)),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      activeColor: const Color(0xffF9703B),
                      onChanged: (value) => _toggleTaskCompletion(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: task.isCompleted
                            ? Colors.grey
                            : const Color(0xff203142),
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF9703B),
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
