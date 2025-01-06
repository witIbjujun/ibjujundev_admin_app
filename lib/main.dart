import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/home/wit_home_main_sc.dart';

void main() {
  runApp(const IbjujunAdminApp());
}

/**
 * 입주전 관리자 메인
 */
class IbjujunAdminApp extends StatelessWidget {
  const IbjujunAdminApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '입주전 관리자',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}