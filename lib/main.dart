import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:student_provider/controller/provider_controller.dart';
import 'package:student_provider/db/student_model.dart';
import 'package:student_provider/ui/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudentProfileAdapter());
  await Hive.openBox<StudentProfile>('students');

  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentProvider(Hive.box<StudentProfile>('students')),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Your App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
