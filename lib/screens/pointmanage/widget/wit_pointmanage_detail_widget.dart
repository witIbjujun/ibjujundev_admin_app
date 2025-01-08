import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/widget/wit_common_util.dart';
import '../../common/widget/wit_common_widget.dart';

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

    int cash = int.parse(widget.pointInfo["cash"] ?? '0');
    int bonusCash = int.parse(widget.pointInfo["bonusCash"] ?? '0');
    int total = cash + bonusCash;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("보너스 충전",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    hintText: "충전 금액을 입력해주세요",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    isDense: true, // 밀도를 높여서 크기를 줄임
                  ),
                  onChanged: (value) {
                    String formattedValue = formatCash(value);
                    widget.controller.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(offset: formattedValue.length),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // 충전금액 입력 체크
                  if (widget.controller.text.isEmpty || widget.controller.text == "0") {
                    alertDialog.show(context, "충전 금액을 입력해주세요");
                    return;
                  }
                  // 저장 여부 확인
                  widget.onAddPressed();
                },
                child: Text("추가"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: Size(0, 35),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("입주전 캐시",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              Text(formatCash(total.toString()) + " 원",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
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
                      child: Text("충전 캐시",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(formatCash(widget.pointInfo["cash"]) + " 원",
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
                        "보너스 캐시",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(formatCash(widget.pointInfo["bonusCash"]) + " 원",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/**
 * 포인트 관리 리스트 뷰
 */
class PointInfoDetailListView extends StatelessWidget {

  final List<dynamic> pointInfoDetailList;
  final Future<void> Function() getList;

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
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  if (item["cashGbn"] == "01" || item["cashGbn"] == "03")
                    Icon(
                      Icons.add, // 파란 더하기 아이콘
                      color: Colors.blue,
                      size: 50,
                    )
                  else if (item["cashGbn"] == "02" || item["cashGbn"] == "04")
                    Icon(
                      Icons.remove, // 빨간 빼기 아이콘
                      color: Colors.red,
                      size: 50,
                    ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("캐시 금액",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(formatCash(item["cash"]) + " 원",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("캐시 구분",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["cashGbnNm"],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("충전 일자",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["creDt"],
                          style: TextStyle(fontSize: 12),
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
    );
  }
}