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
    return Material(
      child: SafeArea(
        child: Container(
          //margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            color: const Color.fromRGBO(152, 224, 173, 1),
            child: loginWindow() //optionButtons()
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
              minimumSize: const Size(200, 50)
          ),
          onPressed: () {},
          child: const Text("Admin"),
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50)
            ),
            onPressed: () {},
            child: const Text("Super admin")
        )
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
                    offset: const Offset(0, 3)
                )
              ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CleanButtonTextField(
                    isReadOnly: false,
                    controlTextField: txtBoxId,
                    placeHolder: "Enter the id",
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CleanButtonTextField(
                    isReadOnly: false,
                    isPassword: true,
                    controlTextField: txtBoxPassword,
                    placeHolder: "Enter the password",
                  ),
                )
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50)
                ),
                onPressed: () {},
                child: const Text("Login"),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50)
                ),
                onPressed: () {},
                child: const Text("Cancel"),
              ),
            ],
          ),
        )
    );
  }
}
