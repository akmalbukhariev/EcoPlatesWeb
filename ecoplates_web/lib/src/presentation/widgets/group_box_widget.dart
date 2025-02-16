
import 'package:ecoplates_web/src/blocs/main_page_cubit.dart';
import 'package:ecoplates_web/src/presentation/widgets/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupBoxWidget extends StatefulWidget {
  final void Function(String phoneNumber) onSearchPressed;

  const GroupBoxWidget({super.key, required this.onSearchPressed});

  @override
  _GroupBoxWidgetState createState() => _GroupBoxWidgetState();
}

class _GroupBoxWidgetState extends State<GroupBoxWidget> {
  bool isDisabled = false;
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 0, bottom: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      enabled: !isDisabled,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter phone number",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 47,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white
                      ),
                      onPressed: isDisabled ? null : () {
                        if(phoneController.text.isEmpty){
                          ShowSnackBar(context: context, message: "Field can not be empty!");
                          return;
                        }
                        widget.onSearchPressed(phoneController.text);
                      },
                      child: const Text("Search"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}