import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/wit_pointmanage_detail.sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

import '../../common/widget/wit_common_util.dart';

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
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item["storeName"],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(8),
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
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
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
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
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