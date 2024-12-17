import 'package:flutter/material.dart';

/**
 * 가입정보 정보조회 메인
 */
class JoinInfoManage extends StatefulWidget {

  // 생성자
  const JoinInfoManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return JoinInfoManageState();
  }
}

/**
 * 가입정보 정보조회 메인 UI
 */
class JoinInfoManageState extends State<JoinInfoManage> {

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
        title: Text("가입정보 정보조회"),
      ),
    );
  }
}