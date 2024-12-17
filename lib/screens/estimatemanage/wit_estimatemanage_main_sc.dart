import 'package:flutter/material.dart';

/**
 * 견적요청 리스트 메인
 */
class EstimateManage extends StatefulWidget {

  // 생성자
  const EstimateManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return EstimateManageState();
  }
}

/**
 * 견적요청 리스트 메인 UI
 */
class EstimateManageState extends State<EstimateManage> {

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
        title: Text("견적요청 리스트"),
      ),
    );
  }
}