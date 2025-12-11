import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:krankmelde_app/Utility/EmailSender.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/VariableController.dart';
import 'package:krankmelde_app/Pages/PagesInterface.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/WriteMailPageWidget.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/EmailTextProcessor.dart';

class WriteMailPage implements PagesInterface {
  late WriteMailPageWidget widget;
  final TextEditingController _emailTextController = VariableController();
  final TextEditingController _betreffTextController = VariableController();

  final List<String> _selectedEmpfaenger = [];
  final List<String> _selectedCCs = [];

  WriteMailPage() {
    widget = WriteMailPageWidget(
      emailTextController: _emailTextController,
      betreffTextController: _betreffTextController,
      selectedCCs: _selectedCCs,
      selectedEmpfaenger: _selectedEmpfaenger,
    );
  }

  @override
  Widget getButtonText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [Icon(Icons.outgoing_mail), Text("Email senden")],
    );
  }

  @override
  void getFunction(BuildContext context) {
    EmailSender.sendEmail(
      context,
      Email(
        body: EmailTextProcessor.replaceWithVariables(_emailTextController.text),
        subject: EmailTextProcessor.replaceWithVariables(_betreffTextController.text),
        recipients: _selectedEmpfaenger,
        cc: _selectedCCs,
      ),
    );
  }

  @override
  NavigationDestination getNavigationDestination() {
    return const NavigationDestination(
      icon: Icon(Icons.mail_outline_rounded),
      label: "E-Mail",
    );
  }

  @override
  Widget getWidget() {
    return widget;
  }
}
