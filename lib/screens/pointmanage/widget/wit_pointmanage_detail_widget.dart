import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * 포인트 충전 상단 UI
 */
class PointInputWidget extends StatefulWidget {
  final dynamic pointInfo;
  final TextEditingController controller;
  final Function onAddPressed;

  PointInputWidget({required this.pointInfo, required this.controller, required this.onAddPressed});

  @override
  _PointInputWidgetState createState() => _PointInputWidgetState();
}

/**
 * 포인트 충전 상단 UI
 */
class _PointInputWidgetState extends State<PointInputWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card( // Card 위젯으로 감싸기
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // 모서리를 둥글게 설정
        ),
        elevation: 4, // 그림자 효과
        child: Padding(
          padding: const EdgeInsets.all(10.0), // 카드 내부 패딩
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "보너스 충전",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller, // TextEditingController 설정
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                      ],
                      textAlign: TextAlign.end, // 텍스트를 오른쪽으로 정렬
                      decoration: InputDecoration(
                        hintText: "충전 금액을 입력해주세요",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // 위아래 간격 조정
                      ),
                      onChanged: (value) {
                        // 입력된 값 포맷팅
                        String formattedValue = formatCash(value);
                        // 포맷팅된 값을 TextField에 다시 설정
                        widget.controller.value = TextEditingValue(
                          text: formattedValue,
                          selection: TextSelection.collapsed(offset: formattedValue.length), // 커서를 마지막에 위치
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // 충전금액 입력 체크
                      if (widget.controller.text.isEmpty || widget.controller.text == "0") {
                        _showAlertDialog("충전 금액을 입력해주세요");
                        return;
                      }

                      // 저장 여부 확인
                      widget.onAddPressed();
                    },
                    child: Text("추가"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 설정
                      ),
                      minimumSize: Size(0, 45), // 높이를 TextField와 같게 설정 (기본 높이는 56.0)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // 버튼과 포인트 텍스트 사이의 간격
              Text(
                "캐시 : " + formatCash(widget.pointInfo["cash"]) + " 원", // 실제 포인트 값으로 변경
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10), // 버튼과 포인트 텍스트 사이의 간격
              Text(
                "보너스 캐시 : " + formatCash(widget.pointInfo["bonusCash"]) + " 원", // 실제 포인트 값으로 변경
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0), // 간격 조절
            ],
          ),
        ),
      ),
    );
  }

  // 알림창 표시
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }
}

/**
 * 포인트 관리 리스트 뷰
 */
class PointInfoDetailListView extends StatelessWidget {
  final List<dynamic> pointInfoDetailList;
  final Future<void> Function() getList; // 메서드 타입으로 변경

  const PointInfoDetailListView({
    required this.pointInfoDetailList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pointInfoDetailList.length,
      itemBuilder: (context, index) {
        final item = pointInfoDetailList[index];
        return GestureDetector(
          child: PointInfoDetailListCard(item: item),
        );
      },
    );
  }
}

/**
 * 포인트 상세 관리 요청 카드
 */
class PointInfoDetailListCard extends StatelessWidget {

  final dynamic item;

  const PointInfoDetailListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 아이콘을 왼쪽 중앙에 위치
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item["cashGbn"] == "01" || item["cashGbn"] == "03")
                Icon(
                  Icons.add, // 파란 더하기 아이콘
                  color: Colors.blue,
                  size: 40,
                )
              else if (item["cashGbn"] == "02" || item["cashGbn"] == "04")
                Icon(
                  Icons.remove, // 빨간 빼기 아이콘
                  color: Colors.red,
                  size: 40,
                ),
            ],
          ),
          SizedBox(width: 16.0), // 아이콘과 텍스트 간격
          // 텍스트는 오른쪽 정렬
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                Text(
                  "캐시  :  ${formatCash(item["cash"])} 원",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4.0), // 간격 조절
                Text(
                  "캐시 구분  :  ${item["cashGbnNm"]}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4.0), // 간격 조절
                Text(
                  "등록일자  :  ${item["creDt"]}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


String formatCash(String cash) {
  // 문자열을 숫자로 변환하고 쉼표를 추가
  String buffer = '';
  int length = cash.length;

  for (int i = 0; i < length; i++) {
    buffer += cash[i];
    // 뒤에서부터 3자리마다 쉼표 추가
    if ((length - i - 1) % 3 == 0 && (length - i - 1) != 0) {
      buffer += ',';
    }
  }

  return buffer;
}