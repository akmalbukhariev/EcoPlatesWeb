import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:ecoplates_web/src/presentation/widgets/dashboard/notification_dashboard.dart';
import 'package:ecoplates_web/src/presentation/widgets/dashboard/search_dashboard.dart';
import 'package:ecoplates_web/src/presentation/widgets/loading_overlay_widget.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_admin.dart';
import 'package:ecoplates_web/src/utils/auth_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_page_cubit.dart';
import '../../blocs/main_page_cubit.dart';
import '../../blocs/main_page_state.dart';
import '../../constant/constants.dart';
import '../../services/data_provider/http_service_company.dart';
import '../../services/data_provider/http_service_user.dart';
import '../widgets/app_alert_dialog_yesno.dart';
import '../widgets/dashboard/company_dashboard.dart';
import '../widgets/dashboard/setting_dashboard.dart';
import '../widgets/dashboard/user_dashboard.dart';
import 'dart:html' as html;

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPage();
}

class _MainDashboardPage extends State<MainDashboardPage> {
  String selectedMenu = Constants.USER;

  late LoginPageCubit loginCubit;
  late AdminRole savedRole = AdminRole.ADMIN;

  @override
  void initState() {
    super.initState();

    loginCubit = context.read<LoginPageCubit>();
    initializeToken();
    initializeRole();
  }

  void initializeToken() async {
    final token = await AuthStorage.getToken();
    if (token != null) {
      context.read<HttpServiceAdmin>().setToken(token);
      context.read<HttpServiceUser>().setToken(token);
      context.read<HttpServiceCompany>().setToken(token);
    } else {
      print('No token found');
    }

    html.window.console.log('AuthStorage.getToken() $token');
    String? strToken = loginCubit.getToken();
    html.window.console.log('loginCubit.getToken() $strToken');
  }

  void initializeRole() async {
    final role = await AuthStorage.getRole();
    if (role != null) {
      savedRole = role;
    } else {
      print('No role found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainPageCubit, MainPageState>(
        builder: (context, state){
          return Stack(
            children: [
              Row(
                children: [
                  // Left Menu Container
                  Container(
                    width: 200,
                    color: const Color.fromRGBO(30, 60, 114, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo/Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: const Color.fromRGBO(25, 55, 100, 1),
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
                        buildMenuItem(Constants.USER, Icons.person, (){
                          setState(() {
                            selectedMenu = Constants.USER;
                          });
                        }),
                        buildMenuItem(Constants.COMPANY, Icons.business, (){
                          setState(() {
                            selectedMenu = Constants.COMPANY;
                          });
                        }),
                        buildMenuItem(Constants.SEARCH, Icons.search, (){
                          setState(() {
                            selectedMenu = Constants.SEARCH;
                          });
                        }),
                        buildMenuItem(Constants.NOTIFICATION, Icons.notifications_active, (){
                          setState(() {
                            selectedMenu = Constants.NOTIFICATION;
                          });
                        }),
                        if(loginCubit.state.adminRole == AdminRole.ADMIN || savedRole == AdminRole.ADMIN)
                          buildMenuItem(Constants.SETTINGS, Icons.settings, (){
                            setState(() {
                              selectedMenu = Constants.SETTINGS;
                            });
                          }),
                        const Expanded(
                            child: SizedBox()
                        ),
                        //Log out button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
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
                            await AuthStorage.saveToken("");

                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Text(
                            Constants.LOG_OUT,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Main Content
                  Expanded(
                    child: Container(
                      color: const Color.fromRGBO(249, 251, 252, 1),
                      child: buildDashboard(),
                    ),
                  ),
                ],
              ),
              if(state.isLoading)
                const LoadingOverlayWidget()
            ],
          );
        }
      )
    );
  }

  Widget buildMenuItem(String title, IconData icon, VoidCallback onClick) {
    bool isSelected = selectedMenu == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
        onClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(20, 50, 100, 1)
              : Colors.transparent,
          borderRadius: isSelected
              ? BorderRadius.circular(0)
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

  Widget buildDashboard() {
    if (selectedMenu == Constants.USER) {
      return const UserDashBoard();
    } else if (selectedMenu == Constants.COMPANY) {
      return const CompanyDashBoard();
    } else if (selectedMenu == Constants.SEARCH){
      return const SearchDashBoard();
    } else if (selectedMenu == Constants.NOTIFICATION){
      return const NotificationDashBoard();
    } else if (selectedMenu == Constants.SETTINGS) {
      return const SettingDashBoard();
    }
    else {
      return const Center(child: Text("Select a menu item"));
    }
  }
}