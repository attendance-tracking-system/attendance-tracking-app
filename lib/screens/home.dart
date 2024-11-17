import 'dart:math';
import 'dart:async';
import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/screens/auth_page.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void logout() {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = AuthService(authProvider);
    authService.logout();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       // child: Center(
  //       //   child: TextButton(onPressed: logout, child: Text("logout")),
  //       // ),
  //       appBar: AppBar(title: Text('Clock In App')),
  //       body: ClockInWidget(),
  //     ),
  //   );
  // }
  late Timer _timer;
  late DateTime _currentDateTime;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  String getFormattedDate() {
    return DateFormat('d MMM, yyyy')
        .format(_currentDateTime); // e.g., "7 Nov, 2024"
  }

  String getFormattedTime() {
    return DateFormat('h:mm a').format(_currentDateTime); // e.g., "5:30 PM"
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Add logout functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logged out successfully!")),
              );
              logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 75,
        title: Text("Welcome, Pavan",style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section: Welcome and Logout
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Welcome, Pavan",
          //         style: TextStyle(
          //           fontSize: 30,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.logout, color: Colors.black),
          //         onPressed: _showLogoutDialog,
          //       ),
          //     ],
          //   ),
          // ),
          // Spacer(), // Pushes the container to the bottom
          // Main Container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            getFormattedDate(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            getFormattedTime(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 16),
                  // Placeholder for useful info
      
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Clock In" action
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text("Clock In pressed!")),
                      // );
                      print("here");
                      context.go('/facecapture');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Clock In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // Add some spacing at the bottom
        ],
      ),
    );
  }
}

class ClockInWidget extends StatefulWidget {
  @override
  _ClockInWidgetState createState() => _ClockInWidgetState();
}

class _ClockInWidgetState extends State<ClockInWidget> {
  late Timer _timer;
  late DateTime _currentDateTime;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  String getFormattedDate() {
    return DateFormat('d MMM, yyyy')
        .format(_currentDateTime); // e.g., "7 Nov, 2024"
  }

  String getFormattedTime() {
    return DateFormat('h:mm a').format(_currentDateTime); // e.g., "5:30 PM"
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 20, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text(
                      getFormattedDate(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 20, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Text(
                      getFormattedTime(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome, Employee!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 28, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle "Clock In" action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Clock In pressed!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "Clock In",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
