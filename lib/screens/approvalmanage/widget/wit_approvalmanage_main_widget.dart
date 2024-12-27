import 'package:flutter/material.dart';

/**
 * 결재내역 리스트 뷰
 */
class ApprovalInfoListView extends StatelessWidget {
  final List<dynamic> approvalInfoList;
  final Future<void> Function() getList;

  const ApprovalInfoListView({
    required this.approvalInfoList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: approvalInfoList.length,
      itemBuilder: (context, index) {
        final item = approvalInfoList[index];
        return GestureDetector(
          onTap: () async {
            /*// 클릭 시 CertificateHolderDetail로 화면 전환
            await Navigator.push(
              context,
              _createRoute(CertificateHolderDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();*/
          },
          child: ApprovalInfoListCard(item: item),
        );
      },
    );
  }
}

/**
 * 결재내역 요청 카드
 */
class ApprovalInfoListCard extends StatelessWidget {
  final dynamic item;

  const ApprovalInfoListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      height: 190, // 카드 높이를 늘림
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Text(
            item["approvalNm"],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // 줄 간격 추가
          Text(
            "결재 ID : " + item["approvalNo"],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8), // 줄 간격 추가
          Text(
            "결재금액 : " + _formatNumber(item["approvalAmt"]),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8), // 줄 간격 추가
          Text(
            "결재처리 결과 : " + item["sendResult"],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8), // 줄 간격 추가
          Text(
            "결재처리 시간 : " + item["resultTime"],
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _formatNumber(String number) {
    // 숫자를 문자열로 변환한 후, 정규 표현식을 사용하여 천 단위 콤마 추가
    return number.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (Match m) => "${m[1]},",
    );
  }
}
