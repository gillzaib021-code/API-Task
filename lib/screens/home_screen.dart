import 'package:flutter/material.dart';
import 'package:week_4_task/model/user_model.dart';
import 'package:week_4_task/screens/profile_screen.dart';
import 'package:week_4_task/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel> usersFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    usersFuture = apiService.fetchUsers();
  }

  Future<void> refreshData() async {
    setState(() {
      usersFuture = apiService.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Users"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading users..."),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        usersFuture = apiService.fetchUsers();
                      });
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data!.results;
          
          if (users == null || users.isEmpty) {
            return Center(child: Text("No users found"));
          }

          return RefreshIndicator(
            onRefresh: refreshData,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: user.picture?.thumbnail != null
                          ? NetworkImage(user.picture!.thumbnail!)
                          : null,
                      child: user.picture?.thumbnail == null
                          ? Text(user.name?.first?[0]?.toUpperCase() ?? '?')
                          : null,
                    ),
                    title: Text(
                      user.name?.getFullName() ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          user.email ?? 'No Email',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          user.phone ?? 'No Phone',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}