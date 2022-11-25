import 'package:flutter/material.dart';
import 'package:gift_grab/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    ),
  );
}
