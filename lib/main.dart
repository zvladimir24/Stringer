import 'package:flutter/material.dart';
import 'package:stringer/app/app.dart';
import 'package:stringer/app/di/injection.dart';

void main() {
  configureDependencies();
  runApp(const App());
}
