import 'package:flutter/material.dart';

/**
 * 견적요청 리스트 뷰
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
            /*// 클릭 시 CertificateHolderDetail로 화면 전환
            await Navigator.push(
              context,
              _createRoute(CertificateHolderDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();*/
          },
          child: EstimateInfoListCard(item: item),
        );
      },
    );
  }
}

/**
 * 포인트 관리 요청 카드
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                item["storeName"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(
                "(${item["bizCertificationNm"]})",
                style: item["bizCertification"] == "01"
                    ? TextStyle(fontSize: 16, color: Colors.green)
                    : item["bizCertification"] == "02"
                    ? TextStyle(fontSize: 16, color: Colors.green)
                    : item["bizCertification"] == "03"
                    ? TextStyle(fontSize: 16, color: Colors.blue)
                    : item["bizCertification"] == "04"
                    ? TextStyle(fontSize: 16, color: Colors.orange)
                    : item["bizCertification"] == "05"
                    ? TextStyle(fontSize: 16, color: Colors.red)
                    : TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
          ),
          Text(
            item["bizCertificationDate"],
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}