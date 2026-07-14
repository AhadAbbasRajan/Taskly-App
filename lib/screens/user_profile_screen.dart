import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _apiUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchAPIUsers();
  }

  Future<void> _fetchAPIUsers() async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=1'));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          _apiUsers = decodedData['data']; // Target the 'data' array from reqres
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to load users. Error Code: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error occurred. Please check your connection.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: const Text("API User Profiles", style: TextStyle(color: Color(0xff203142))),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff203142)),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xffF9703B)))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _apiUsers.length,
        itemBuilder: (context, index) {
          final user = _apiUsers[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xffE4E7EB)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
                backgroundColor: Colors.grey.shade200,
              ),
              title: Text("${user['first_name']} ${user['last_name']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff203142))),
              subtitle: Text(user['email'], style: const TextStyle(color: Color(0xff4C5980))),
            ),
          );
        },
      ),
    );
  }
}