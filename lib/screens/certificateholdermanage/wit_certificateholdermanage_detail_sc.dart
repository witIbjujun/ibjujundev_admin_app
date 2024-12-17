import 'package:flutter/material.dart';

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
  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();
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

  Widget buildDetailRow(String title, String value) {
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
            child: Text(
              value,
              textAlign: TextAlign.end, // 오른쪽 정렬
              style: TextStyle(fontSize: 16),
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
              buildDetailRow("사업자번호", widget.itemInfo["storeCode"]),
              buildDetailRow("인증 상태", widget.itemInfo["bizCertificationNm"]),
              buildDetailRow("인증 요청일", widget.itemInfo["bizCertificationDate"]),
            ],
          ),
        ),
      ),
    );
  }
}
