import 'package:flutter/material.dart';

import '../views/task_list_view.dart';

class Cau1App extends StatelessWidget {
  const Cau1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-do List Firestore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const TaskListView(),
    );
  }
}
