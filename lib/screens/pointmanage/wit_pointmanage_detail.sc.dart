import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/widget/wit_pointmanage_detail_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

/**
 * 포인트 관리 상세 화면
 */
class PointManageDetail extends StatefulWidget {
  final dynamic itemInfo;

  // 생성자
  const PointManageDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PointManageDetailState();
  }
}

/**
 * 포인트 관리 상세 화면 UI
 */
class PointManageDetailState extends State<PointManageDetail> {

  // 포인트 상세 정보 리스트
  List<dynamic> pointInfoDetailList = [];

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    // 포인트 상세 정보 조회
    getPointInfoDetailList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("포인트 관리 상세"),
      ),
      body: SafeArea(
        child: pointInfoDetailList.isEmpty
            ? Center(
          child: Text(
            "조회된 데이터가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : PointInfoDetailListView(
          pointInfoDetailList: pointInfoDetailList,
          getList: getPointInfoDetailList, // 메서드의 참조를 전달
        ),
      ),
    );
  }

  // [서비스] 포인트 상세 정보 조회
  Future<void> getPointInfoDetailList() async {

    // 데이터 초기화
    pointInfoDetailList = [];

    // REST ID
    String restId = "getPointInfoDetailList";

    // PARAM
    final param = jsonEncode({
      "cashNo" : widget.itemInfo["cashNo"]
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final _pointInfoDetailList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      pointInfoDetailList.addAll(_pointInfoDetailList);
    });
  }

}

