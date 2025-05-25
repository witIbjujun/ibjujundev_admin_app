import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/wit_ImageViewer_sc.dart';

/**
 * 사업자 상세 ROW UI
 */
Widget partnerDetailRow(String title, String value, {Widget? action}) {
  return Column( // Column으로 변경하여 Padding과 줄을 배치
    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // 항목 간의 간격 조정
        child: Column( // Column으로 변경하여 두 줄로 배치
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Text(
              title,
              style: WitCommonTheme.title,
            ),
            SizedBox(height: 4),
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
              onPressed: () async {
                if (itemInfo["certificationYn"] == "N") {
                  bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"협력업체 승인 하시겠습니까?");
                  if (isConfirmed == true) {
                    updatePartnerYn("Y");
                  }
                } else {
                  bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"협력업체 승인 취소 하시겠습니까?");
                  if (isConfirmed == true) {
                    updatePartnerYn("N");
                  }
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
                    ? "협력업체 승인 취소" : "협력업체 승인",
                style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// 이미지 리스트 영역
class ImageListDisplay extends StatelessWidget {
  final List<dynamic> imageList;

  ImageListDisplay({
    required this.imageList,
  });

  @override
  Widget build(BuildContext context) {
    return imageList.length > 0 ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // 항목 간의 간격 조정
      child: Container(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  SlideRoute(page: ImageViewer(
                    imageUrls: imageList.map((item) => apiUrl + item["imagePath"]).toList(),
                    initialIndex: index,
                  )),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(apiUrl + imageList[index]["imagePath"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ) : Container();
  }
}