import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/wit_estimatemanage_detail_sc.dart';

/**
 * 견적요청 리스트 위젯
 */
class EstimateInfoListView extends StatelessWidget {
  final List<dynamic> estimateInfoList;
  final Future<void> Function() getList;

  const EstimateInfoListView({
    required this.estimateInfoList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: estimateInfoList.length,
      itemBuilder: (context, index) {
        final item = estimateInfoList[index];
        return GestureDetector(
          onTap: () async {
            // 클릭 시 EstimateInfoDetail 화면 전환
            await Navigator.push(
              context,
              SlideRoute(page: EstimateInfoDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();
          },
          child: EstimateInfoListCard(item: item),
        );
      },
    );
  }
}

/**
 * 포인트 관리 요청 카드 위젯
 */
class EstimateInfoListCard extends StatelessWidget {
  final dynamic item;

  const EstimateInfoListCard({required this.item});

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
      child: Column( // Row에서 Column으로 변경
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item["storeName"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "업체번호 : ${item["sllrNo"]}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8), // 간격 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "견적 대기 : ${item["waitCnt"]}건",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8), // 간격 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "견적 진행 : ${item["goingCnt"]}건",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8), // 간격 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "견적 취소 : ${item["cencelCnt"]}건",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}