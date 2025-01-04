import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: Text("포인트 상세 [" + widget.itemInfo["storeName"] + "]"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 포인트 입력 UI
            PointInputWidget(
              pointInfo : widget.itemInfo,
              controller: _controller,
              onAddPressed: () {
                // 저장 여부 확인
                _showConfirmationDialog(context);
              },
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

      _showAlertDialog("입력한 금액이 충전 되었습니다.");
    } else {
      _showAlertDialog("충전중 오류가 발생 되었습니다.");
    }
  }

  // 확인 다이얼로그 표시
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("확인"),
          content: Text("[ " + widget.itemInfo["storeName"] + " ] 에게"
              + "\n\n입력한 포인트를 등록하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("아니오"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text("예"),
              onPressed: () {
                // 여기에 포인트 등록 로직 추가
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 포인트 저장
                savePointInfo();
              },
            ),
          ],
        );
      },
    );
  }

  // 알림창 표시
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

}


