import 'package:flutter/material.dart';

class Themeprovider extends ChangeNotifier {
  bool istapped = false;

  void Changetheme() {
    istapped = !istapped;
    notifyListeners();
  }
}
