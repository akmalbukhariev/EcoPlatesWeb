import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/user_dashboard.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPage();
}

class _MainDashboardPage extends State<MainDashboardPage> {
  String selectedMenu = 'Users'; // Tracks which menu is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Menu Container
          Container(
            width: 200,
            color: const Color.fromRGBO(30, 60, 114, 1), // Blue background
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo/Header
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color.fromRGBO(25, 55, 100, 1), // Slightly darker blue
                  child: const Text(
                    'Ecoplates Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Menu Items
                _buildMenuItem('User', Icons.person, (){
                  setState(() {
                    selectedMenu = 'User';
                  });
                }),
                _buildMenuItem('Company', Icons.business, (){
                  setState(() {
                    selectedMenu = 'Company';
                  });
                }),
                _buildMenuItem('Settings', Icons.settings, (){
                  setState(() {
                    selectedMenu = 'Settings';
                  });
                }),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color.fromRGBO(249, 251, 252, 1), // Light background
              child: _buildDashboard(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to Build Menu Items with Animation
  Widget _buildMenuItem(String title, IconData icon, VoidCallback onClick) {
    bool isSelected = selectedMenu == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
        onClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(20, 50, 100, 1) // Highlighted background
              : Colors.transparent, // Default background
          borderRadius: isSelected
              ? BorderRadius.circular(0) // Rounded corners for the selected item
              : BorderRadius.zero,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Dashboard Based on Selected Menu
  Widget _buildDashboard() {
    if (selectedMenu == 'User') {
      return userDashboard("4520"); // Pass total user count as an example
    } else if (selectedMenu == 'Company') {
      return companyDashboard();
    } else if (selectedMenu == 'Settings') {
      return settingsPage();
    } else {
      return const Center(child: Text("Select a menu item"));
    }
  }
}

Widget companyDashboard() {
  return const Center(
    child: Text("Company Dashboard"),
  );
}

Widget settingsPage() {
  return const Center(
    child: Text("Settings Page"),
  );
}