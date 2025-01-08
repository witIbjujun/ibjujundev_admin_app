import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/wit_estimatemanage_detail_sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_util.dart';

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
        return EstimateInfoListCard(
          item : item,
          onTap: () async {
            await Navigator.push(
              context,
              SlideRoute(page: EstimateInfoDetail(itemInfo: item)),
            );
            await getList();
          },
        );
      },
    );
  }
}

/**
 * 사업자 인증 요청 카드
 */
class EstimateInfoListCard extends StatefulWidget {

  final dynamic item;
  final VoidCallback onTap;

  const EstimateInfoListCard({required this.item, required this.onTap});

  @override
  _EstimateInfoListCardState createState() => _EstimateInfoListCardState();
}

class _EstimateInfoListCardState extends State<EstimateInfoListCard> {

  Color _backgroundColor = Colors.white; // 초기 배경 색상

  @override
  Widget build(BuildContext context) {
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
                Column(
                  children: [
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "견적 요청",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  formatCash(widget.item["waitCnt"]) + " 건",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "견적 발송",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  formatCash(widget.item["goingCnt"]) + " 건",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
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