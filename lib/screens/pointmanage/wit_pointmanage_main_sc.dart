import 'package:flutter/material.dart';

/**
 * 포인트 관리 메인
 */
class PointManage extends StatefulWidget {

  // 생성자
  const PointManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PointManageState();
  }
}

/**
 * 포인트 관리 메인 UI
 */
class PointManageState extends State<PointManage> {

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("포인트 관리"),
      ),
    );
  }
}