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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '입주전 관리자',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}