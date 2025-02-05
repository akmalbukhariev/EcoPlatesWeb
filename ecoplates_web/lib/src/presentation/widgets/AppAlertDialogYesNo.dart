
import 'package:flutter/material.dart';

class AppAlertDialogYesNo {
  static Future<bool?> showAlert({
    required BuildContext context,
    required String title,
    required String content,
    String yesText = "Yes",
    String noText = "No",
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  // Return false when "No" is clicked
              },
              child: Text(noText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // Return true when "Yes" is clicked
              },
              child: Text(yesText),
            ),
          ],
        );
      },
    );
  }
}
