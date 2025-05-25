import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/widget/wit_pointmanage_detail_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

import '../common/widget/wit_common_widget.dart';

/**
 * 포인트 관리 상세 화면
 */
class PointManageDetail extends StatefulWidget {

  final dynamic itemInfo;

  const PointManageDetail({super.key, required this.itemInfo});

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
  // 포인트충전 INPUT 컨트롤러
  final TextEditingController _controller = TextEditingController();

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
        title: Text("포인트 상세 [" + widget.itemInfo["storeName"] + "]",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white, // 배경색을 흰색으로 설정
          child: Column(
            children: [
              // 포인트 입력 UI
              PointInputWidget(
                pointInfo: widget.itemInfo,
                controller: _controller,
                onAddPressed: () async {
                  bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"[ " + widget.itemInfo["storeName"] + " ] 에게\n입력한 포인트를 등록하시겠습니까?");
                  if (isConfirmed == true) {
                    savePointInfo();
                  }
                },
              ),
              Container(
                height: 10,
                color: Colors.grey[200],
              ),
              // 리스트 데이터 표시
              pointInfoDetailList.isEmpty
                  ? Expanded(
                child: Center(
                  child: Text(
                    "조회된 데이터가 없습니다.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  : Expanded(
                child: PointInfoDetailListView(
                  pointInfoDetailList: pointInfoDetailList,
                  getList: getPointInfoDetailList, // 메서드의 참조를 전달
                ),
              ),
            ],
          ),
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

  // [서비스] 포인트 저장
  Future<void> savePointInfo() async {

    // REST ID
    String restId = "updateCashInfo";

    // PARAM
    final param = jsonEncode({
      "cashNo" : widget.itemInfo["cashNo"],
      "sllrNo" : widget.itemInfo["sllrNo"],
      "cashGbn" : "03",
      "cash" : _controller.text.replaceAll(",", ""),
      "creUser" : "72091588",
      "updUser" : "72091588",
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final saveResult = await sendPostRequest(restId, param);

    // 저장 성공
    if (saveResult > 0) {

      // 결과 셋팅
      setState(() {
        // 입력된 값을 숫자로 변환하고 bonusCash에 더하기
        int addedCash = int.parse(_controller.text.replaceAll(",", ""));
        int bonusCash = int.parse(widget.itemInfo["bonusCash"]);

        // bonusCash가 String 타입이라면
        widget.itemInfo["bonusCash"] = (bonusCash + addedCash).toString();
      });

      // 초기화
      _controller.text = "";
      // 포인트 상세 정보 조회
      getPointInfoDetailList();

      alertDialog.show(context: context, title:"알림", content: "입력한 금액이 충전 되었습니다.");
    } else {
      alertDialog.show(context: context, title:"알림", content: "충전중 오류가 발생 되었습니다.");
    }
  }
}


