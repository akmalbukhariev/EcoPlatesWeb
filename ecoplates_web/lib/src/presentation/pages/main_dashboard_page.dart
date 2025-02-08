import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_page_cubit.dart';
import '../../blocs/login_page_state.dart';
import '../../constant/constants.dart';
import '../widgets/app_alert_dialog_yesno.dart';
import '../widgets/company_dashboard.dart';
import '../widgets/setting_dashboard.dart';
import '../widgets/user_dashboard.dart';
import 'admin_option_page.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPage();
}

class _MainDashboardPage extends State<MainDashboardPage> {
  String selectedMenu = Constants.USER;

  late LoginPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginPageCubit, LoginPageState>(
        builder: (context, state){
          return Row(
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
                    if(state.adminRole == AdminRole.ADMIN)
                      _buildMenuItem(Constants.SETTINGS, Icons.settings, (){
                      setState(() {
                        selectedMenu = Constants.SETTINGS;
                      });
                    }),
                    Expanded(
                        child: SizedBox()
                    ),
                    //Log out button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: Colors.red,        // Set background color to red
                        shape: RoundedRectangleBorder(      // Rectangle shape
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final bool? confirm = await AppAlertDialogYesNo.showAlert(
                          context: context,
                          title: "Confirmation",
                          content: "Do you really want to log out?",
                          yesText: "Yes",
                          noText: "No",
                        );

                        if (confirm != true) return;

                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text(
                        Constants.LOG_OUT,
                        style: TextStyle(color: Colors.white),  // Optional: Set text color to white for contrast
                      ),
                    )
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
          );
        }
      )
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
      return const SettingDashBoard();
    } else {
      return const Center(child: Text("Select a menu item"));
    }
  }
}