import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

/**
 * 사업자 인증 상세 화면
 */
class CertificateHolderDetail extends StatefulWidget {
  final dynamic itemInfo;

  // 생성자
  const CertificateHolderDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return CertificateHolderDetailState();
  }
}

/**
 * 사업자 인증 상세 화면 UI
 */
class CertificateHolderDetailState extends State<CertificateHolderDetail> {

  bool isBizNo = false;
  bool isCertificateHolderYes = false;
  bool isCertificateHolderRe = false;
  bool isCertificateHolderNo = false;

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();
    
    // 요청중 (01)
    if (widget.itemInfo["bizCertification"] == "01") {
      isBizNo = false;                // 활성화
      isCertificateHolderYes = true;  // 비활성화
      isCertificateHolderRe = false;  // 활성화
      isCertificateHolderNo = false;  // 활성화

    // 사업자번호 인증완료 (02)
    } else if (widget.itemInfo["bizCertification"] == "02") {
      isBizNo = true;                 // 비활성화
      isCertificateHolderYes = false; // 활성화
      isCertificateHolderRe = false;  // 활성화
      isCertificateHolderNo = false;  // 활성화

    // 사업자 인증완료
    } else if (widget.itemInfo["bizCertification"] == "03") {
      isBizNo = true;                 // 비활성화
      isCertificateHolderYes = true;  // 비활성화
      isCertificateHolderRe = false;  // 활성화
      isCertificateHolderNo = false;  // 활성화

    // 재등록 요청 (04), 불가처리 (05)
    } else if (widget.itemInfo["bizCertification"] == "04" || widget.itemInfo["bizCertification"] == "05") {
      isBizNo = true;                 // 비활성화
      isCertificateHolderYes = true;  // 비활성화
      isCertificateHolderRe = true;   // 비활성화
      isCertificateHolderNo = true;   // 비활성화
    }
  }

  /**
   * [유틸] 폰번호 포맷
   */
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
    }
    return phoneNumber;
  }

  /**
   * [유틸] 날짜 포맷
   */
  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String year = parsedDate.year.toString();
    String month = parsedDate.month.toString().padLeft(2, '0'); // 01, 02 형태로
    String day = parsedDate.day.toString().padLeft(2, '0'); // 01, 02 형태로
    return '$year년 $month월 $day일'; // 형식화된 문자열 반환
  }

  Widget buildDetailRow(String title, String value, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0), // 항목 간의 간격 조정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
                if (action != null) action, // 버튼 추가
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("사업자 인증 상세"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
            children: [
              buildDetailRow("사업자명", widget.itemInfo["storeName"]),
              buildDetailRow("대표자명", widget.itemInfo["name"]),
              buildDetailRow("대표 이메일", widget.itemInfo["email"]),
              buildDetailRow("담당자 연락처", formatPhoneNumber(widget.itemInfo["hp"])),
              buildDetailRow("사업장 우편번호", widget.itemInfo["zipCode"]),
              buildDetailRow("사업장 주소", widget.itemInfo["address1"]),
              buildDetailRow("개업일자", formatDate(widget.itemInfo["openDate"])),
              buildDetailRow(
                "사업자번호",
                widget.itemInfo["storeCode"] + "   ",
                action: ElevatedButton(
                  onPressed: isBizNo ? null : () {
                    // 사업자 번호 인증
                    checkBizNo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // 버튼 모서리 둥글게
                    ),
                  ),
                  child: widget.itemInfo["bizCertification"] == "01"
                      ? Text("인증")
                      : widget.itemInfo["bizCertification"] == "02"
                      ? Text("인증완료")
                      : widget.itemInfo["bizCertification"] == "03"
                      ? Text("인증완료")
                      : widget.itemInfo["bizCertification"] == "04"
                      ? Text("재인증요청")
                      : widget.itemInfo["bizCertification"] == "05"
                      ? Text("인증")
                      : Text("상태 없음"),
                ),
              ),
              buildDetailRow("인증 상태", widget.itemInfo["bizCertificationNm"]),
              buildDetailRow("인증 요청일", widget.itemInfo["bizCertificationDate"]),
              SizedBox(height: 20), // 간격 조정
              buildActionButtons(context), // 인증 완료 및 불가 버튼
            ],
          ),
        ),
      ),
    );
  }

  // 인증 완료 및 불가 버튼
  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderYes
                ? null
                : () {
              _showConfirmationDialog(
                context,
                "인증 완료 처리 하시겠습니까?", // 메시지 전달
                    () => updateBizCertification("03"),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary, // AppBar와 동일한 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // 모서리 둥글게
              ),
            ),
            child: Text("인증 완료"),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderRe
                ? null
                : () {
              _showConfirmationDialog(
                context,
                "재인증 요청을 하시겠습니까?", // 메시지 전달
                    () => updateBizCertification("04"),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.outlineVariant, // AppBar와 동일한 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // 모서리 둥글게
              ),
            ),
            child: Text("재인증 요청"),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderNo
                ? null
                : () {
              _showConfirmationDialog(
                context,
                "인증 불가 처리 하시겠습니까?", // 메시지 전달
                    () => updateBizCertification("05"),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade200, // 연한 빨강
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // 모서리 둥글게
              ),
            ),
            child: Text("인증 불가"),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String message, Future<void> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("확인"),
          content: Text(message), // 메시지를 파라미터로 받음
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                onConfirm(); // 실행할 메서드 호출
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }


  // [서비스] 사업자 인증
  Future<void> checkBizNo(BuildContext context) async {
    // PARAM
    final param = jsonEncode({
      "businesses" : [{
        //"b_no" : "8922900486",
        //"start_dt" : "20171122",
        //"p_nm" : "조성훈"
        "b_no" : widget.itemInfo["storeCode"],
        "start_dt" : widget.itemInfo["openDate"],
        "p_nm" : widget.itemInfo["name"]

      }]
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final result = await sendPostRequestByBizCd(param);

    if (result["status_code"] == "OK") {

      var obj = result["data"][0];

      // 사업자번호 정상이면
      if (obj["valid"] == "01") {
        setState(() {
          isBizNo = true;
          isCertificateHolderYes = false;
        });

        print("TEST11111111111111111111111111111111111111111111111111111111");
        updateBizCertification("02");
      }

      _showPopup(context, obj);

    // 사업자번호 인증 실패
    } else {
      var obj = {};
      obj["b_no"] = widget.itemInfo["storeCode"];
      obj["tax_type"] = "사업자번호 인증 실패";

      _showPopup(context, obj);
    }
  }

  // [서비스] 사업자 인증 상태 변경
  Future<void> updateBizCertification(String biz) async {

    // REST ID
    String restId = "updateBizCertification";

    // PARAM
    final param = jsonEncode({
      "sllrNo" : widget.itemInfo["sllrNo"],
      "bizCertification" : biz
    });

    // API 호출 (사업자 인증 상태 변경)
    final result = await sendPostRequest(restId, param);

    setState(() {
      widget.itemInfo["bizCertification"] = biz;
    });

  }

  // [팝업] 사업자 정보 팝업
  void _showPopup(BuildContext context, var obj) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사업자 인증 결과"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("사업자등록번호", obj["b_no"]),
                _buildInfoRow("진위확인 결과 코드", obj["valid"]),
                /*_buildInfoRow("진위확인 결과 메세지", obj["valid_msg"]),

                _buildInfoRow("폐업일", obj["request_param"]),
                _buildInfoRow("단위과세전환폐업여부", obj["request_param"]),
                _buildInfoRow("최근과세유형전환일자", obj["request_param"]),
                _buildInfoRow("세금계산서적용일자", obj["request_param"]),
                _buildInfoRow("직전과세유형메세지", obj["request_param"]),*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 정보 행을 생성하는 메서드
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

}

