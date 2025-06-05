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
                  style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
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
                        style: WitCommonTheme.caption,
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
            child: Text("인증 완료", style: WitCommonTheme.subtitle),
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
            child: Text("재인증 요청", style: WitCommonTheme.subtitle),
          ),
        ),
        SizedBox(width: 10), // 버튼 간격
        Expanded(
          child: ElevatedButton(
            onPressed: isCertificateHolderNo
                ? null
                : () async {

              bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"불량 업체로 등록 하시겠습니까?");

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
            child: Text("불량 업체", style: WitCommonTheme.subtitle),
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

    print(obj);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // AlertDialog의 기본 배경색은 흰색입니다.
          title: Text("사업자 인증 결과",
              style: WitCommonTheme.title
          ),
          content: SingleChildScrollView( // 내용이 길어지면 스크롤 가능
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("사업자등록번호", obj["b_no"], WitCommonTheme.wit_white),
                _buildInfoRow("개업일자", obj["request_param"]["start_dt"], WitCommonTheme.wit_white),
                _buildInfoRow("대표자명", obj["request_param"]["p_nm"], WitCommonTheme.wit_white),
                _buildInfoRow("사업자 인증 결과", obj["valid"] == "01" ? "인증성공" : "인증실패",
                    obj["valid"] == "01" ? WitCommonTheme.wit_lightBlue : WitCommonTheme.wit_lightCoral),
                if ( obj["valid"] == "02") ...[
                  _buildInfoRow("실패내용", obj["valid_msg"], WitCommonTheme.wit_lightCoral),
                ]
              ],
            ),
          ),
          actions: <Widget>[ // actions에 포함된 위젯은 다이얼로그 하단에 배치됩니다.
            Container( // 구분선
              height: 1,
              color: WitCommonTheme.wit_lightgray,
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          // actionsPadding이나 buttonPadding 등으로 버튼 영역의 패딩을 조절할 수 있습니다.
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: WitCommonTheme.wit_gray),
            ),
            child: Text(
              label,
              style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value,
                style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
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