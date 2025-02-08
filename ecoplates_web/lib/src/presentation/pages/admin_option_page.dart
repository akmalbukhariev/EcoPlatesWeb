import 'package:ecoplates_web/src/blocs/login_page_cubit.dart';
import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:ecoplates_web/src/presentation/widgets/clean_button_text_field.dart';
import 'package:ecoplates_web/src/presentation/widgets/loading_overlay_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_page_state.dart';
import '../../constant/result.dart';
import 'main_dashboard_page.dart';

class AdminOptionPage extends StatefulWidget{
  const AdminOptionPage({super.key});

  @override
  State<AdminOptionPage> createState() => _AdminOptionPage();
}

class _AdminOptionPage extends State<AdminOptionPage> {
  late final TextEditingController txtBoxId;
  late final TextEditingController txtBoxPassword;

  late LoginPageCubit cubit;

  @override
  void initState() {
    super.initState();
    txtBoxId = TextEditingController();
    txtBoxPassword = TextEditingController();

    cubit = context.read<LoginPageCubit>();
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is destroyed
    txtBoxId.dispose();
    txtBoxPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginPageCubit, LoginPageState>(
        builder: (context, state){
          return SafeArea(
            child: Container(
              /*decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFED7D95),  // Light coral-pink tone (from image)
                    Color(0xFF624DCE),  // Deep blue-purple tone
                  ],
                ),
              ),*/
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: state.showLoginWindow ? -MediaQuery.of(context).size.width : 0,
                    top: 0,
                    right: state.showLoginWindow ? MediaQuery.of(context).size.width : 0,
                    bottom: 0,
                    duration: const Duration(milliseconds: 500),
                    child: optionButtons(),
                  ),
                  AnimatedPositioned(
                    left: state.showLoginWindow ? 0 : MediaQuery.of(context).size.width,
                    top: 0,
                    right: state.showLoginWindow ? 0 : -MediaQuery.of(context).size.width,
                    bottom: 0,
                    duration: const Duration(milliseconds: 500),
                    child: loginWindow(),
                  ),
                  if(state.isLoading)
                    const LoadingOverlayWidget()
                ],
              ),
            ),
          );
        }
      )
    );
  }

  Widget optionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            cubit.setShowLoginWindow(show: true);
            cubit.setAdminRole(adminRole: AdminRole.ADMIN);
          },
          child: const Text("Admin"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            cubit.setShowLoginWindow(show: true);
            cubit.setAdminRole(adminRole: AdminRole.SUPER_ADMIN);
          },
          child: const Text("Super admin"),
        ),
      ],
    );
  }

  Widget loginWindow() {
    return Center(
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: txtBoxId,
                      decoration: const InputDecoration(
                        hintText: "Enter the id",
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: txtBoxPassword,
                  decoration: const InputDecoration(
                    hintText: "Enter the password",
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () async {
                String msg = await cubit.login(adminId: txtBoxId.text, password: txtBoxPassword.text);

                if (msg == Result.SUCCESS.message) {
                  /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainDashboardPage()),
                  );*/

                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                cubit.setShowLoginWindow(show: false);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
