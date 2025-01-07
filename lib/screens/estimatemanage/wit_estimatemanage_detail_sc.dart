import 'package:flutter/material.dart';

/**
 * 업체별 상태별 견적 리스트 UI
 */
class EstimateInfoDetail extends StatefulWidget {
  final dynamic itemInfo;

  // 생성자
  const EstimateInfoDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return EstimateInfoDetailState();
  }
}

/**
 * 업체별 상태별 견적 리스트 UI
 */
class EstimateInfoDetailState extends State<EstimateInfoDetail> {

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
        title: Text("업체별 상세 견적 정보",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            // TabBar를 AppBar 아래에 위치
            TabBar(
              tabs: [
                Tab(text: "진행 (${widget.itemInfo["goingCnt"]})"),
                Tab(text: "대기 (${widget.itemInfo["waitCnt"]})"),
                Tab(text: "완료 (${widget.itemInfo["cencelCnt"]})"),
                Tab(text: "취소 (${widget.itemInfo["cencelCnt"]})"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // 견적 진행
                  ListView.builder(
                    itemCount: 10, // 예시 데이터 개수
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("진행 항목 ${index + 1}"),
                      );
                    },
                  ),
                  // 견적 대기
                  ListView.builder(
                    itemCount: 10, // 예시 데이터 개수
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("대기 항목 ${index + 1}"),
                      );
                    },
                  ),
                  // 견적 완료
                  ListView.builder(
                    itemCount: 10, // 예시 데이터 개수
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("완료 항목 ${index + 1}"),
                      );
                    },
                  ),
                  // 견적 취소
                  ListView.builder(
                    itemCount: 10, // 예시 데이터 개수
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("취소 항목 ${index + 1}"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}