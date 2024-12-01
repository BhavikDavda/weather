import 'package:flutter/material.dart';

class WebProvider extends ChangeNotifier{
  double progress=1;

  void onChangeProgress(int progress){
    this.progress=progress/100;
    notifyListeners();
  }
}