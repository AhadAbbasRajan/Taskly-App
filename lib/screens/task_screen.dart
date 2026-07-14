import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly_app/task_provider.dart';
import 'login_screen.dart';
import 'user_profile_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _showAddTaskDialog(TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task", style: TextStyle(color: Color(0xff203142))),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: "What do you need to do?"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Color(0xff4C5980))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF9703B)),
              onPressed: () {
                provider.addTask(_taskController.text);
                _taskController.clear();
                Navigator.pop(context);
              },
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
        title: const Text(
          "My Tasks",
          style: TextStyle(color: Color(0xff203142), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Color(0xff323F4B)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xffF9703B)),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text("No tasks yet. Tap + to add one!", style: TextStyle(color: Color(0xff4C5980))));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: task.isCompleted ? Colors.grey.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffE4E7EB)),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    activeColor: const Color(0xffF9703B),
                    onChanged: (value) => taskProvider.toggleTaskCompletion(index),
                  ),
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 16,
                      color: task.isCompleted ? Colors.grey : const Color(0xff203142),
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                    child: Text(task.title),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => taskProvider.deleteTask(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return FloatingActionButton(
              backgroundColor: const Color(0xffF9703B),
              onPressed: () => _showAddTaskDialog(taskProvider),
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
      ),
    );
  }
}