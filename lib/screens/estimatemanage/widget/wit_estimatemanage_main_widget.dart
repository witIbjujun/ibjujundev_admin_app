import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/wit_estimatemanage_detail_sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_util.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';

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
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: WitCommonTheme.wit_extraLightGrey, // 연한 회색 테두리
                        width: 1, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4), // 이미지 모서리 둥글게
                      child: Image.network(
                        apiUrl + widget.item["storeImage"],
                        width: 70,
                        height: 70,
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
                      color: WitCommonTheme.wit_extraLightGrey,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: WitCommonTheme.wit_extraLightGrey,
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
                        widget.item["storeName"] ?? "",
                        style: WitCommonTheme.title,
                      ),
                      SizedBox(height: 10),
                      Row( // 이 Row는 Column의 자식입니다.
                        children: [
                          Expanded( // 이 Expanded는 이 Row 내에서 자식들이 공간을 어떻게 나눌지 제어합니다.
                            child: Row( // 이 Row가 Container와 Text를 포함합니다.
                              crossAxisAlignment: CrossAxisAlignment.center, // <-- 이 부분입니다! 자식들을 수직 중앙에 정렬합니다.
                              children: [
                                // 인증 여부를 표시할 네모 박스
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: WitCommonTheme.wit_lightgray,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "견적 요청",
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded( // Text를 Expanded로 감싸서 남은 공간을 차지하게 합니다.
                                  child: Text(
                                    formatCash(widget.item["waitCnt"]) + " 건",
                                    style: WitCommonTheme.caption,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: WitCommonTheme.wit_lightgray,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "견적 발송",
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded( // Text를 Expanded로 감싸서 남은 공간을 차지하게 합니다.
                                  child: Text(
                                    formatCash(widget.item["goingCnt"]) + " 건",
                                    style: WitCommonTheme.caption,
                                  ),
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
              color: WitCommonTheme.wit_extraLightGrey,
            ),
          ],
        ),
      ),
    );
  }
}