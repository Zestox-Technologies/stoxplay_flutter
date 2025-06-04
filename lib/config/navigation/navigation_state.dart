import 'package:flutter/material.dart';

class NavigationState {
  static final NavigationState _instance = NavigationState._internal();
  factory NavigationState() => _instance;
  NavigationState._internal();

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  
  void updateIndex(int index) {
    currentIndex.value = index;
  }
} 