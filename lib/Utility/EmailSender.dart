import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:io' show Platform;
import 'package:krankmelde_app/Utility/AlertNotification.dart';

class EmailSender {
  //öffnet auf dem Handy das Standard Email Programm und füllt die Felder mit den Daten der übergebenen Email aus
  static void sendEmail(BuildContext context, Email email) async{
    if(Platform.isAndroid || Platform.isIOS){
      try{
        FlutterEmailSender.send(email);
        if(context.mounted) AlertNotification.alert('Email verschickt.',context);
      }catch(error){
        if(context.mounted) AlertNotification.alert('Email nicht verschickt.',context);
      }
    }
  }
}