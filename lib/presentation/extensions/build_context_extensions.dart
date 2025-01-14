import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  bool listenWhen(String title) => ModalRoute.of(this)?.settings.name == title;
}
