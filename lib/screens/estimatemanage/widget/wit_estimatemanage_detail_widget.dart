import 'package:flutter/material.dart';

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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  Text(item["itemName"],
                    style: TextStyle(fontSize: 12),
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
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(item["stat"],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["aptName"],
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
                          child: Text("요청자",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["prsnName"],
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
                          child: Text("요청 일자",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item["estDt"],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item["reqContents"] + "테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용", // 요청 내용을 표시
                        style: TextStyle(fontSize: 12),
                        maxLines: 5, // 최대 줄 수 설정 (필요에 따라 조정)
                        overflow: TextOverflow.visible, // 넘치는 경우 표시
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
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