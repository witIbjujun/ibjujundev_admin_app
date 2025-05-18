import 'package:flutter/material.dart';

import '../../common/widget/wit_common_theme.dart';

/**
 * 업체별 상세 견적 리스트 뷰
 */
class EstimateListView extends StatelessWidget {
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

/**
 * 업체별 상세 견적 카드
 */
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
}