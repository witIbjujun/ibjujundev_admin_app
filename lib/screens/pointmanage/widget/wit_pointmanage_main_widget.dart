import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/wit_pointmanage_detail.sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

/**
 * 포인트 관리 리스트 뷰
 */
class PointInfoListView extends StatelessWidget {
  final List<dynamic> pointInfoList;
  final Future<void> Function() getList; // 메서드 타입으로 변경

  const PointInfoListView({
    required this.pointInfoList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pointInfoList.length,
      itemBuilder: (context, index) {
        final item = pointInfoList[index];
        return InkWell(
          onTap: () async {
            // 클릭 시 PointManageDetail 화면 전환
            await Navigator.push(
              context,
              SlideRoute(page: PointManageDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();
          },
          child: PointInfoListCard(item: item),
        );
      },
    );
  }
}

/**
 * 포인트 관리 요청 카드
 */
class PointInfoListCard extends StatelessWidget {

  final dynamic item;

  const PointInfoListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
            children: [
              Text(
                item["storeName"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "(업체번호 : ${item["sllrNo"]})",
                style: TextStyle(fontSize: 12, color: Colors.grey), // 폰트 사이즈 12, 회색으로 설정
              ),
            ],
          ),

          SizedBox(height: 10.0), // 간격 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
            children: [
              Text(
                "포인트 : ${formatCash(item["cash"])} 원",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8.0), // 간격 조절
          Text(
            "보너스 포인트 : ${formatCash(item["bonusCash"])} 원",
            style: TextStyle(fontSize: 16),
          ), // 간격 조절
        ],
      ),
    );
  }

  String formatCash(String cash) {
    // 문자열을 숫자로 변환하고 쉼표를 추가
    String buffer = '';
    int length = cash.length;

    for (int i = 0; i < length; i++) {
      buffer += cash[i];
      // 뒤에서부터 3자리마다 쉼표 추가
      if ((length - i - 1) % 3 == 0 && (length - i - 1) != 0) {
        buffer += ',';
      }
    }

    return buffer;
  }

}