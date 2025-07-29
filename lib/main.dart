import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodbeginner/todo/toDoPage.dart';
import 'counter/counterScreen.dart';

void main() {
  runApp(
    ProviderScope( // 👈 required for Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Counter',
      home: TodoPage(),
      // home: CounterScreen(),
    );
  }
}
