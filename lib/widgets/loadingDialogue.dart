import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, String title, int seconds, Future<void> onEnd) {
  // Show the dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog by tapping outside
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Please Wait"),
          ],
        ),
      );
    },
  );

  // Close the dialog after 3 seconds
  Future.delayed( Duration(seconds: seconds), () {
    Navigator.of(context).pop();
   onEnd;
  });
}