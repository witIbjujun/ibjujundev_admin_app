import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

import '../../common/widget/wit_common_theme.dart';

/**
 * 사업자 상세 ROW UI
 */
Widget partnerDetailRow(String title, String value, {Widget? action}) {
  return Column( // Column으로 변경하여 Padding과 줄을 배치
    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0), // 항목 간의 간격 조정
        child: Column( // Column으로 변경하여 두 줄로 배치
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Text(
              title,
              style: WitCommonTheme.title,
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: WitCommonTheme.subtitle,
                      ),
                      if (action != null) action, // 버튼 추가
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: 1, // 줄의 높이
        color: WitCommonTheme.wit_extraLightGrey, // 줄의 색상
      ),
    ],
  );
}

/**
 * 사업자 상세 버튼 UI
 */
class partnerButtonWidget extends StatelessWidget {

  final dynamic itemInfo;
  final Future<void> Function(String) updatePartnerYn;

  const partnerButtonWidget({
    Key? key,
    required this.itemInfo,
    required this.updatePartnerYn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                if (itemInfo["certificationYn"] == "N") {
                  updatePartnerYn("Y");
                } else {
                  updatePartnerYn("N");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: itemInfo["certificationYn"] == "Y"
                    ? WitCommonTheme.wit_lightCoral : WitCommonTheme.wit_lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(
                itemInfo["certificationYn"] == "Y"
                    ? "협력업체 승인 취소" : "협력업체 승인 요청",
                style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
              ),
            ),
          ),
        )
      ],
    );
  }
}