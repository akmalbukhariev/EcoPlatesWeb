import 'package:ecoplates_web/src/presentation/widgets/CleanButtonTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminOptionPage extends StatefulWidget{
  const AdminOptionPage({super.key});

  @override
  State<AdminOptionPage> createState() => _AdminOptionPage();
}

class _AdminOptionPage extends State<AdminOptionPage> {
  late final TextEditingController txtBoxId;
  late final TextEditingController txtBoxPassword;

  bool showLoginWindow = false; // State to control visibility

  @override
  void initState() {
    super.initState();
    txtBoxId = TextEditingController();
    txtBoxPassword = TextEditingController();
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
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              left: showLoginWindow ? -MediaQuery.of(context).size.width : 0,
              top: 0,
              right: showLoginWindow ? MediaQuery.of(context).size.width : 0,
              bottom: 0,
              duration: const Duration(milliseconds: 500),
              child: optionButtons(),
            ),
            AnimatedPositioned(
              left: showLoginWindow ? 0 : MediaQuery.of(context).size.width,
              top: 0,
              right: showLoginWindow ? 0 : -MediaQuery.of(context).size.width,
              bottom: 0,
              duration: const Duration(milliseconds: 500),
              child: loginWindow(),
            ),
          ],
        ),
      ),
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
            setState(() {
              showLoginWindow = true; // Show login window
            });
          },
          child: const Text("Admin"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            setState(() {
              showLoginWindow = true; // Show login window
            });
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
              onPressed: () {},
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                setState(() {
                  showLoginWindow = false; // Hide login window
                });
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
