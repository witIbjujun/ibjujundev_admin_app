import 'package:flutter/material.dart';

import '../../common/widget/wit_common_theme.dart';
import '../../common/widget/wit_common_widget.dart';

/**
 * 업체별 상세 견적 리스트 뷰
 */
/*class EstimateListView extends StatelessWidget {
  final List<dynamic> estimateList;

  const EstimateListView({super.key, required this.estimateList});

  @override
  Widget build(BuildContext context) {
    if (estimateList.isEmpty) {
      return Center(
        child: Text(
          "조회된 데이터가 없습니다.",
          style: WitCommonTheme.title,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: estimateList.length,
        itemBuilder: (context, index) {
          final item = estimateList[index];
          return GestureDetector(
            child: EstimateListCard(item: item),
          );
        },
      );
    }
  }
}

*//**
 * 업체별 상세 견적 카드
 *//*
class EstimateListCard extends StatelessWidget {

  final dynamic item;

  const EstimateListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: WitCommonTheme.wit_lightBlue,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: WitCommonTheme.wit_extraLightGrey,
                        width: 1,
                      ),
                    ),
                  ),
                  Text(item["itemName"] ?? "",
                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                          decoration: BoxDecoration(
                            color: WitCommonTheme.wit_lightBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(item["stat"] ?? "상태 없음",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["aptName"] ?? "",
                          style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: WitCommonTheme.wit_extraLightGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("요청자",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["prsnName"] ?? "",
                          style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
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
                          child: Text("요청 일자",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["estDt"] ?? "",
                          style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100, // 최소 높이 200 설정
            ),
            child: Container(
              color: WitCommonTheme.wit_extraLightGrey, // 배경색 회색 설정
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10), // 좌우 0, 위아래 10의 패딩 추가
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0), // 외부 여백 추가
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item["reqContents"] ?? "",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                            maxLines: 99, // 최대 줄 수 설정 (필요에 따라 조정)
                            overflow: TextOverflow.visible, // 넘치는 경우 표시
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 1,
            color: WitCommonTheme.wit_extraLightGrey,
          ),
        ],
      ),
    );
  }
}*/


class EstimateListView extends StatelessWidget {
  final List<dynamic> estimateList;
  final Future<void> Function() getList;

  const EstimateListView({
    required this.estimateList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: estimateList.length,
      itemBuilder: (context, index) {
        final item = estimateList[index];
        return EstimateCard(
          item: item,
        );
      },
    );
  }
}

/**
 * 사업자 인증 요청 카드
 */
class EstimateCard extends StatefulWidget {

  final dynamic item;

  const EstimateCard({required this.item});

  @override
  _EstimateCardState createState() => _EstimateCardState();
}

class _EstimateCardState extends State<EstimateCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Row의 자식들을 세로 중앙에 정렬합니다.
                      children: [
                        Expanded( // 첫 번째 항목이 Row의 왼쪽 절반을 차지하도록 합니다.
                          child: Row( // 첫 번째 항목 내부의 가로 레이아웃
                            crossAxisAlignment: CrossAxisAlignment.center, // 이 Row의 자식들을 세로 중앙에 정렬합니다.
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: WitCommonTheme.wit_lightGreen,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: WitCommonTheme.wit_gray),
                                ),
                                child: Text("아파트명",
                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded( // Text가 남은 공간을 모두 차지하도록 합니다.
                                child: Text(widget.item["aptName"] ?? "",
                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                                  maxLines: null, // 내용이 길면 줄바꿈되도록 합니다.
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded( // 두 번째 항목이 Row의 오른쪽 절반을 차지하도록 합니다.
                          child: Row( // 두 번째 항목 내부의 가로 레이아웃
                            crossAxisAlignment: CrossAxisAlignment.center, // 이 Row의 자식들을 세로 중앙에 정렬합니다.
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: WitCommonTheme.wit_lightGreen,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: WitCommonTheme.wit_gray),
                                ),
                                child: Text("요청상태",
                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(widget.item["stat"] ?? "",
                                style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Row의 자식들을 세로 중앙에 정렬합니다.
                      children: [
                        Expanded( // 첫 번째 항목이 Row의 왼쪽 절반을 차지하도록 합니다.
                          child: Row( // 첫 번째 항목 내부의 가로 레이아웃
                            crossAxisAlignment: CrossAxisAlignment.center, // 이 Row의 자식들을 세로 중앙에 정렬합니다.
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: WitCommonTheme.wit_white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: WitCommonTheme.wit_gray),
                                ),
                                child: Text("견적업종",
                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(widget.item["itemName"] ?? "",
                                style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                              ),
                            ],
                          ),
                        ),
                        Expanded( // 두 번째 항목이 Row의 오른쪽 절반을 차지하도록 합니다.
                          child: Row( // 두 번째 항목 내부의 가로 레이아웃
                            crossAxisAlignment: CrossAxisAlignment.center, // 이 Row의 자식들을 세로 중앙에 정렬합니다.
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: WitCommonTheme.wit_white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: WitCommonTheme.wit_gray),
                                ),
                                child: Text("요청자명",
                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(widget.item["prsnName"] ?? "",
                                style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: WitCommonTheme.wit_white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: WitCommonTheme.wit_gray),
                          ),
                          child: Text("견적형태",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(widget.item["reqType"] ?? "",
                          style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: WitCommonTheme.wit_white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: WitCommonTheme.wit_gray),
                          ),
                          child: Text("요청일자",
                            style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(widget.item["estDt"] ?? "",
                          style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 75,
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                color: WitCommonTheme.wit_white,
                border: Border.all(
                  color: WitCommonTheme.wit_extraLightGrey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row( // 가장 바깥쪽 Row
                crossAxisAlignment: CrossAxisAlignment.start, // 이 Row의 자식들을 세로 상단에 정렬합니다.
                children: [
                  Expanded(
                    child: Row( // 텍스트를 포함하는 안쪽 Row
                      crossAxisAlignment: CrossAxisAlignment.start, // 이 부분도 유지하여 안쪽 Row의 자식 정렬에 영향을 줍니다.
                      children: [
                        Expanded(
                          child: Align( // Align 위젯으로 Text를 감쌉니다.
                            alignment: Alignment.topLeft, // 상단 왼쪽에 명시적으로 정렬합니다.
                            child: Text(
                              widget.item["reqContents"] ?? "",
                              style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 1,
            color: WitCommonTheme.wit_extraLightGrey,
          ),
        ],
      ),
    );
  }
}