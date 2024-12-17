import 'package:flutter/material.dart';

/**
 * 협력업체 인증관리 메인
 */
class PartnerManage extends StatefulWidget {

  // 생성자
  const PartnerManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PartnerManageState();
  }
}

/**
 * 협력업체 인증관리 메인 UI
 */
class PartnerManageState extends State<PartnerManage> {

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
        title: Text("협력업체 인증관리"),
      ),
    );
  }
}