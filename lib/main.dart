import 'package:flutter/material.dart';
import 'package:thinknest/features/auth/screens/login_screen.dart';
import 'package:thinknest/theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: Pallete.lightModeAppTheme,
      theme: Pallete.darkModeAppTheme,
      home: const LoginScreen(),
    );
  }
}
