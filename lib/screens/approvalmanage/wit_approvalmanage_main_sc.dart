import 'package:flutter/material.dart';

/**
 * 결재내역 조회 메인
 */
class ApprovalManage extends StatefulWidget {

  // 생성자
  const ApprovalManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return ApprovalManageState();
  }
}

/**
 * 결재내역 조회 메인 UI
 */
class ApprovalManageState extends State<ApprovalManage> {

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
        title: Text("결재내역 조회"),
      ),
    );
  }
}