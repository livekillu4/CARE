import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

abstract class PagesInterface {
  Widget getButtonText();
  Widget getWidget();
  void getFunction(BuildContext context);
  NavigationDestination getNavigationDestination();
}