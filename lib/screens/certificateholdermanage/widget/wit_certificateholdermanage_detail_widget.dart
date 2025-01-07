import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

/**
 * 사업자 상세 ROW UI
 */
Widget buildDetailRow(String title, String value, {Widget? action}) {
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 12),
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
        color: Colors.grey[200], // 줄의 색상
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
                : () {
              ConfirmationDialog.show(context, "인증 완료 처리 하시겠습니까?",
                () async {
                  await updateBizCertification("03");
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                : () {
              ConfirmationDialog.show(
                context,
                "재인증 요청을 하시겠습니까?",
                    () async {
                  await updateBizCertification("04");
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiaryFixed,
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
                : () {
              ConfirmationDialog.show(
                context,
                "인증 불가 처리 하시겠습니까?",
                    () async {
                  await updateBizCertification("05");
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text("인증 불가"),
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