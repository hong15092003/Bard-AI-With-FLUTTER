import 'Pages/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Pages/History.dart';
import 'Pages/Setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PINK AI',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
       // Define the routes
      routes: {
        '/home': (context) => const HomePage(),
        '/history': (context) => const ChatHistoryPage(), // Make sure you have a ChatHistoryPage widget
        '/setting': (context) => Settings(), // Make sure you have a Settings widget
      },
    );
  }

}