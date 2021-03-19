import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {


  String selectedCategory = "";


  void updateCategoryId(String selectedCategory) {
    this.selectedCategory  = selectedCategory;
    notifyListeners();
  }


}