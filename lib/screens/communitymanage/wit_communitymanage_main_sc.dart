import 'package:flutter/material.dart';

/**
 * 커뮤니티 관리 메인
 */
class CommunityManage extends StatefulWidget {

  // 생성자
  const CommunityManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return CommunityManageState();
  }
}

/**
 * 커뮤니티 관리 메인 UI
 */
class CommunityManageState extends State<CommunityManage> {

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
        title: Text("커뮤니티 관리"),
      ),
    );
  }
}