import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/wit_pointmanage_detail.sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_util.dart';

import '../../../util/wit_code_ut.dart';

/**
 * 포인트 관리 리스트 뷰
 */
class PointInfoListView extends StatelessWidget {

  final List<dynamic> pointInfoList;
  final Future<void> Function() getList;

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
        return PointInfoListCard(
          item: item,
          onTap: () async {
            await Navigator.push(
              context,
              SlideRoute(page: PointManageDetail(itemInfo: item)),
            );
            await getList();
          },
        );
      },
    );
  }
}

/**
 * 포인트 관리 요청 카드
 */
class PointInfoListCard extends StatefulWidget {

  final dynamic item;
  final VoidCallback onTap;

  const PointInfoListCard({required this.item, required this.onTap});

  @override
  _PointInfoListCardState createState() => _PointInfoListCardState();
}

class _PointInfoListCardState extends State<PointInfoListCard> {

  Color _backgroundColor = Colors.white; // 초기 배경 색상

  @override
  Widget build(BuildContext context) {

    int cash = int.parse(widget.item["cash"] ?? '0');
    int bonusCash = int.parse(widget.item["bonusCash"] ?? '0');
    int total = cash + bonusCash;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _backgroundColor = Colors.grey[200]!;
        });
      },
      onTapUp: (_) {
        setState(() {
          _backgroundColor = Colors.white;
        });
      },
      onTapCancel: () {
        setState(() {
          _backgroundColor = Colors.white;
        });
      },
      onTap: widget.onTap,
      child: Container(
        color: _backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                if (widget.item["storeImage"] != null) ...[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5), // 연한 회색 테두리
                        width: 1, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4), // 이미지 모서리 둥글게
                      child: Image.network(
                        apiUrl + widget.item["storeImage"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // 이미지와 텍스트 사이 여백
                ],
                if (widget.item["storeImage"] == null) ...[
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item["storeName"],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("입주전 캐시",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(width: 10),
                Text(formatCash(total.toString()) + " 원",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("충전 캐시",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(formatCash(widget.item["cash"]) + " 원",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("보너스 캐시",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(formatCash(widget.item["bonusCash"]) + " 원",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}