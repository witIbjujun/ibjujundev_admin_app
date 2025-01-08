import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/widget/wit_estimatemanage_detail_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

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
  // 업체별 견적 리스트
  List<dynamic> requestEstimateList = [];
  List<dynamic> sentEstimateList = [];

  // 현재 상태
  String estStat = "01";

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    getEstimateInfoDetailList(estStat);
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("업체별 상세 견적 정보 [" + widget.itemInfo["storeName"] + "]",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "견적 요청 (${widget.itemInfo["waitCnt"]})"),
                Tab(text: "견적 발송 (${widget.itemInfo["goingCnt"]})"),
              ],
              onTap: (index) {
                estStat = index == 0 ? "01" : ""; // 상태 설정
                getEstimateInfoDetailList(estStat);
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // TAB1 : 견적 요청
                  EstimateListView(estimateList: requestEstimateList),
                  // TAB2 : 견적 발송
                  EstimateListView(estimateList: sentEstimateList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [서비스] 업체별 견적 리스트 조회
  Future<void> getEstimateInfoDetailList(String estStat) async {

    // 데이터 초기화
    if (estStat == "01") {
      requestEstimateList = [];
    } else {
      sentEstimateList = [];
    }

    // REST ID
    String restId = "getEstimateRequestList";

    // PARAM
    final param = jsonEncode({
      "sllrNo": widget.itemInfo["sllrNo"],
      "stat": estStat,
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final _estimateInfoDetailList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      if (estStat == "01") {
        requestEstimateList = _estimateInfoDetailList;  // 견적 요청 데이터
      } else {
        sentEstimateList = _estimateInfoDetailList;     // 견적 발송 데이터
      }
    });
  }
}
