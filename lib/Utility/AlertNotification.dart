import 'package:flutter/material.dart';

class AlertNotification {
  // Diese Funktion lässt an der BottomNavigationBar eine Snackbar anzeigen, mit einer Nachricht
  static void alert(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text,style: TextStyle(color: Colors.white)), 
        duration: Duration(seconds: 2),
        backgroundColor:
        Color(0xFF7A959E)
        //  Color.fromARGB(255, 0, 117, 130)
         ,
      ),
    );
  }
}
