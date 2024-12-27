import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/wit_pointmanage_detail.sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

/**
 * 포인트 관리 리스트 뷰
 */
class PointInfoDetailListView extends StatelessWidget {
  final List<dynamic> pointInfoDetailList;
  final Future<void> Function() getList; // 메서드 타입으로 변경

  const PointInfoDetailListView({
    required this.pointInfoDetailList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pointInfoDetailList.length,
      itemBuilder: (context, index) {
        final item = pointInfoDetailList[index];
        return GestureDetector(
          child: PointInfoDetailListCard(item: item),
        );
      },
    );
  }
}

/**
 * 포인트 상세 관리 요청 카드
 */
class PointInfoDetailListCard extends StatelessWidget {

  final dynamic item;

  const PointInfoDetailListCard({required this.item});

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
      child: Row(
        children: [
          // 아이콘을 왼쪽 중앙에 위치
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item["cashGbn"] == "01" || item["cashGbn"] == "03")
                Icon(
                  Icons.add, // 파란 더하기 아이콘
                  color: Colors.blue,
                  size: 40,
                )
              else if (item["cashGbn"] == "02" || item["cashGbn"] == "04")
                Icon(
                  Icons.remove, // 빨간 빼기 아이콘
                  color: Colors.red,
                  size: 40,
                ),
            ],
          ),
          SizedBox(width: 16.0), // 아이콘과 텍스트 간격
          // 텍스트는 오른쪽 정렬
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                Text(
                  "포인트  :  ${formatCash(item["cash"])} 원",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 4.0), // 간격 조절
                Text(
                  "포인트 구분  :  ${item["cashGbnNm"]}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4.0), // 간격 조절
                Text(
                  "등록일자  :  ${item["creDt"]}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
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