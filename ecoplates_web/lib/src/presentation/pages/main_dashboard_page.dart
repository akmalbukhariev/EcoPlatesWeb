import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/constants.dart';
import '../widgets/company_dashboard.dart';
import '../widgets/user_dashboard.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPage();
}

class _MainDashboardPage extends State<MainDashboardPage> {
  String selectedMenu = Constants.USER;

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
                    Constants.ECOPLATES_ADMIN,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Menu Items
                _buildMenuItem(Constants.USER, Icons.person, (){
                  setState(() {
                    selectedMenu = Constants.USER;
                  });
                }),
                _buildMenuItem(Constants.COMPANY, Icons.business, (){
                  setState(() {
                    selectedMenu = Constants.COMPANY;
                  });
                }),
                _buildMenuItem(Constants.SETTINGS, Icons.settings, (){
                  setState(() {
                    selectedMenu = Constants.SETTINGS;
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

  Widget _buildDashboard() {
    if (selectedMenu == Constants.USER) {
      return const UserDashBoard();
    } else if (selectedMenu == Constants.COMPANY) {
      return const CompanyDashBoard();
    } else if (selectedMenu == Constants.SETTINGS) {
      return settingsPage();
    } else {
      return const Center(child: Text("Select a menu item"));
    }
  }
}

Widget settingsPage() {
  return const Center(
    child: Text("Settings Page"),
  );
}