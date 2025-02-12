import 'package:ecoplates_web/src/blocs/login_page_cubit.dart';
import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:ecoplates_web/src/constant/constants.dart';
import 'package:ecoplates_web/src/presentation/widgets/loading_overlay_widget.dart';
import 'package:ecoplates_web/src/presentation/widgets/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_page_state.dart';
import '../../constant/result.dart';
import '../../services/data_provider/http_service_company.dart';
import '../../services/data_provider/http_service_user.dart';
import '../../utils/auth_storage.dart';

class AdminOptionPage extends StatefulWidget{
  const AdminOptionPage({super.key});

  @override
  State<AdminOptionPage> createState() => _AdminOptionPage();
}

class _AdminOptionPage extends State<AdminOptionPage> {
  late final TextEditingController txtBoxId;
  late final TextEditingController txtBoxPassword;
  late final FocusNode idFocusNode;
  late final FocusNode passwordFocusNode;
  late final FocusNode loginButtonFocusNode;

  late LoginPageCubit loginCubit;

  @override
  void initState() {
    super.initState();
    txtBoxId = TextEditingController();
    txtBoxPassword = TextEditingController();
    idFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    loginButtonFocusNode = FocusNode();

    loginCubit = context.read<LoginPageCubit>();
  }

  @override
  void dispose() {
    txtBoxId.dispose();
    txtBoxPassword.dispose();
    idFocusNode.dispose();
    passwordFocusNode.dispose();
    loginButtonFocusNode.dispose();

    super.dispose();
  }

  void handleLogin() async {
    if (loginCubit.state.adminRole == AdminRole.ADMIN && txtBoxId.text.toUpperCase() != Constants.ADMIN) {
      ShowSnackBar(context: context, message: "The admin ID must be \"admin\"");
      return;
    } else if (loginCubit.state.adminRole == AdminRole.SUPER_ADMIN && txtBoxId.text.toUpperCase() == Constants.ADMIN) {
      ShowSnackBar(context: context, message: "Please choose the admin role as the admin.");
      return;
    }

    String msg = await loginCubit.login(adminId: txtBoxId.text, password: txtBoxPassword.text);

    if (msg == Result.SUCCESS.message) {
      final token = loginCubit.getToken();
      AuthStorage.saveToken(token as String);

      context.read<HttpServiceUser>().setToken(token);
      context.read<HttpServiceCompany>().setToken(token);

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ShowSnackBar(context: context, message: msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginPageCubit, LoginPageState>(
        builder: (context, state){
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFED7D95),  // Light coral-pink tone (from image)
                    Color(0xFF624DCE),  // Deep blue-purple tone
                  ],
                ),
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
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
              )
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
            txtBoxId.text = "";
            txtBoxPassword.text = "";
            loginCubit.setShowLoginWindow(show: true);
            loginCubit.setAdminRole(adminRole: AdminRole.ADMIN);
          },
          child: const Text("Admin"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            txtBoxId.text = "";
            txtBoxPassword.text = "";
            loginCubit.setShowLoginWindow(show: true);
            loginCubit.setAdminRole(adminRole: AdminRole.SUPER_ADMIN);
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
                      focusNode: idFocusNode,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) => FocusScope.of(context).requestFocus(passwordFocusNode),
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
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => handleLogin(),
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
              onPressed: handleLogin,
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                loginCubit.setShowLoginWindow(show: false);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
