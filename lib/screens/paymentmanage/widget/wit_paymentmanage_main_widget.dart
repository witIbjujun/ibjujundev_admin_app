import 'package:flutter/material.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../../util/wit_code_ut.dart';

/**
 * 협력업체 인증관리 리스트 뷰
 */
class PaymentListView extends StatelessWidget {
  final List<dynamic> paymentList;
  final Future<void> Function() getPaymentList;

  const PaymentListView({
    required this.paymentList,
    required this.getPaymentList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paymentList.length,
      itemBuilder: (context, index) {
        final item = paymentList[index];
        return PaymentCard(
          item: item,
          onTap: () async {

          },
        );
      },
    );
  }
}

/**
 * 협력업체 인증관리 카드
 */
class PaymentCard extends StatefulWidget {

  final dynamic item;
  final VoidCallback onTap;

  const PaymentCard({required this.item, required this.onTap});

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {

  Color _backgroundColor = WitCommonTheme.wit_white; // 초기 배경 색상

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child : Container(
        decoration: BoxDecoration( // BoxDecoration 추가
          color: WitCommonTheme.wit_extraLightGrey,
          borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게 설정 (값은 조절 가능)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${widget.item["storeName"]}",
                            style: WitCommonTheme.title
                        ),
                        SizedBox(height: 5),
                        paymentDetailRow("결재 목록", widget.item["aptName"], WitCommonTheme.wit_lightGreen),
                        SizedBox(height: 5),
                        paymentDetailRow("결재 금액", _formatNumber(widget.item["amount"] ?? "0") + "원", WitCommonTheme.wit_lightGreen),
                        SizedBox(height: 5),
                        paymentDetailRow2("결재 방식", _getPayMethodNm(widget.item["payMethod"] ?? ""), "결재 상태", _getPayStatNm(widget.item["status"] ?? ""), WitCommonTheme.wit_lightGreen),
                        SizedBox(height: 5),
                        paymentDetailRow("결재 날짜", widget.item["creDate"], WitCommonTheme.wit_lightOrchid),
                        SizedBox(height: 5),
                        paymentDetailRow("결재 URL", widget.item["receiptUrl"], WitCommonTheme.wit_lightOrchid),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color:WitCommonTheme.wit_extraLightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/**
 * 결재 내역 ROW UI
 */
Widget paymentDetailRow(String title, String value, Color color) {
  return Column( // Column으로 변경하여 Padding과 줄을 배치
    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
    children: [
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
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    title,
                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                  ),
                ),
                SizedBox(width: 10),
                Expanded( // Text를 Expanded로 감싸서 남은 공간을 차지하게 합니다.
                  child: Text(
                    value,
                    style: WitCommonTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

/**
 * 결재 내역 ROW UI
 */
Widget paymentDetailRow2(String title1, String value1, String title2, String value2, Color color) {
  return Column( // Column으로 변경하여 Padding과 줄을 배치
    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
    children: [
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
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    title1,
                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                  ),
                ),
                SizedBox(width: 10),
                Expanded( // Text를 Expanded로 감싸서 남은 공간을 차지하게 합니다.
                  child: Text(
                    value1,
                    style: WitCommonTheme.caption,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    title2,
                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                  ),
                ),
                SizedBox(width: 10),
                Expanded( // Text를 Expanded로 감싸서 남은 공간을 차지하게 합니다.
                  child: Text(
                    value2,
                    style: WitCommonTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

String _formatNumber(String number) {
  // 숫자를 문자열로 변환한 후, 정규 표현식을 사용하여 천 단위 콤마 추가
  return number.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
        (Match m) => "${m[1]},",
  );
}

String _getPayMethodNm(String payMethod) {

  String payMethodNm = "";

  if (payMethod == "card") {
    payMethodNm = "카드";
  } else if (payMethod == "cash") {
    payMethodNm = "현금";
  } else {
    payMethodNm = "기타";
  }

  return payMethodNm;
}

String _getPayStatNm(String payStat) {

  String payStatNm = "";

  if (payStat == "paid") {
    payStatNm = "결제 성공";
  } else if (payStat == "failed") {
    payStatNm = "결제 실패";
  } else if (payStat == "ready") {
    payStatNm = "결재 대기";
  } else if (payStat == "cancelled") {
    payStatNm = "결재 취소";
  }

  return payStatNm;
}






