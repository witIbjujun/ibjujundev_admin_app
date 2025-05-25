import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/wit_ImageViewer_sc.dart';

/**
 * 사업자 상세 ROW UI
 */
Widget buildDetailRow(String title, String value, bool pointFlag, {Widget? action}) {
  return Column( // Column으로 변경하여 Padding과 줄을 배치
    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // 항목 간의 간격 조정
        child: Column( // Column으로 변경하여 두 줄로 배치
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Row(
              children: [
                if (pointFlag == true)...[
                  Text(
                    "*  ",
                    style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_red),
                  ),
                ],
                Text(
                  title,
                  style: WitCommonTheme.title,
                ),
              ],
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
class ActionButtonWidget extends StatelessWidget {
  final bool isCertificateHolderYes;
  final bool isCertificateHolderRe;
  final bool isCertificateHolderNo;
  final Future<void> Function(String) updateBizCertification;

  const ActionButtonWidget({
    Key? key,
    required this.isCertificateHolderYes,
    required this.isCertificateHolderRe,
    required this.isCertificateHolderNo,
    required this.updateBizCertification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderYes
                ? null
                : () async {

              bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"인증 완료 처리 하시겠습니까?");

              if (isConfirmed == true) {
                updateBizCertification("03");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WitCommonTheme.wit_lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text("인증 완료"),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderRe
                ? null
                : () async {

              bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"재인증 요청을 하시겠습니까?");

              if (isConfirmed == true) {
                updateBizCertification("04");
              }

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WitCommonTheme.wit_lightGoldenrodYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text("재인증 요청"),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderNo
                ? null
                : () async {

              bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"인증 취소 처리 하시겠습니까?");

              if (isConfirmed == true) {
                updateBizCertification("05");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WitCommonTheme.wit_lightCoral,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text("인증 취소"),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
      ],
    );
  }
}

/**
 * 사업자 정보 팝업
 */
class bizInfoDialog {
  static void show(BuildContext context, var obj) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사업자 인증 결과",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("사업자등록번호", obj["b_no"]),
                _buildInfoRow("진위확인 결과 코드", obj["valid"]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
            decoration: BoxDecoration(
              color: Colors.grey[200], // 배경 색상
              borderRadius: BorderRadius.circular(4), // 라운드 처리
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
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