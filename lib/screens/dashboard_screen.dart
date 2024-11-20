import 'dart:async';

import 'package:attendance_tracking_app/providers/auth_provider.dart';
import 'package:attendance_tracking_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;
  late DateTime _currentDateTime;
  bool _isLoading = true;
  late Map<String, dynamic> _userDetails;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _currentDateTime = DateTime.now();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchUserDetails();
    });
  }

  Future<void> fetchUserDetails() async {
    AuthService authService = AuthService(authProvider);
    await authService.isLoggedIn();
    await authService.getUserDetails();

    setState(() {
      _isLoading = false;
      _userDetails = authProvider.user!;
    });
    return;
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

  void logout() async{
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final AuthService authService = AuthService(authProvider);
    await authService.logout();
    context.go('/');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

  Widget StaggeredLoading() {
    return Scaffold(
        body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 100,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? StaggeredLoading()
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 75,
              title: Text(
                "Welcome, ${_userDetails["first_name"]}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: _showLogoutDialog,
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
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
                            // context.pushNamed('/facecapture');
                            // Navigator.push(context, '/facecapture')
                            // context.push('/facecapture');
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
                            "Clock ${_userDetails["punch_status"] == "OUT" ? "In" : "Out"}",
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
