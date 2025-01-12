import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/wit_estimatemanage_detail_sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_util.dart';

import '../../../util/wit_code_ut.dart';

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