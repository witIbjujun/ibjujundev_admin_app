import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/certificateholdermanage/wit_certificateholdermanage_detail_sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_code_ut.dart';

import '../../common/widget/wit_common_theme.dart';

/**
 * 사업자 인증 요청 리스트 뷰
 */
class CertificateHolderListView extends StatelessWidget {
  final List<dynamic> certificateHolderList;
  final Future<void> Function() getList;

  const CertificateHolderListView({
    required this.certificateHolderList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: certificateHolderList.length,
      itemBuilder: (context, index) {
        final item = certificateHolderList[index];
        return CertificateHolderCard(
          item: item,
          onTap: () async {
            await Navigator.push(
              context,
              SlideRoute(page: CertificateHolderDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();
          },
        );
      },
    );
  }
}

/**
 * 사업자 인증 요청 카드
 */
class CertificateHolderCard extends StatefulWidget {

  final dynamic item;
  final VoidCallback onTap;

  const CertificateHolderCard({required this.item, required this.onTap});

  @override
  _CertificateHolderCardState createState() => _CertificateHolderCardState();
}

class _CertificateHolderCardState extends State<CertificateHolderCard> {

  Color _backgroundColor = WitCommonTheme.wit_white; // 초기 배경 색상

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _backgroundColor = WitCommonTheme.wit_extraLightGrey;
        });
      },
      onTapUp: (_) {
        setState(() {
          _backgroundColor = WitCommonTheme.wit_white;
        });
      },
      onTapCancel: () {
        setState(() {
          _backgroundColor = WitCommonTheme.wit_white;
        });
      },
      onTap: widget.onTap, // 클릭 시 onTap 콜백 실행
      child: Container(
        color: _backgroundColor, // 배경 색상 적용
        child: Column(
          children: [
            SizedBox(height: 20), // Row 위에 빈 공간 추가
            Row(
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    // 이미지가 존재할 경우에만 표시
                    if (widget.item["storeImage"] != null) ...[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: WitCommonTheme.wit_gray.withOpacity(0.5), // 연한 회색 테두리
                            width: 1, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4), // 이미지 모서리 둥글게
                          child: Image.network(
                            apiUrl + widget.item["storeImage"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15), // 이미지와 텍스트 사이 여백
                    ],
                    if (widget.item["storeImage"] == null) ...[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: WitCommonTheme.wit_extraLightGrey,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: WitCommonTheme.wit_extraLightGrey,
                            width: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Text(
                        widget.item["storeName"],
                        style: WitCommonTheme.title,
                      ),
                      SizedBox(height: 10), // 텍스트 간격
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // 인증 여부를 표시할 네모 박스
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                                  decoration: BoxDecoration(
                                    color: WitCommonTheme.wit_lightGreen, // 배경 색상
                                    borderRadius: BorderRadius.circular(4), // 라운드 처리
                                  ),
                                  child: Text(
                                    "인증여부", // 인증 여부 텍스트
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white), // 텍스트 스타일
                                  ),
                                ),
                                SizedBox(width: 10), // 박스와 텍스트 사이의 간격
                                Text(
                                  "${widget.item["bizCertificationNm"]}",
                                  style: WitCommonTheme.caption
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5), // 텍스트 간격
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // 요청 일자를 표시할 네모 박스
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 패딩 추가
                                  decoration: BoxDecoration(
                                    color: WitCommonTheme.wit_lightgray, // 배경 색상
                                    borderRadius: BorderRadius.circular(4), // 라운드 처리
                                  ),
                                  child: Text(
                                    "요청일자", // 요청 일자 텍스트
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white), // 텍스트 스타일
                                  ),
                                ),
                                SizedBox(width: 10), // 박스와 텍스트 사이의 간격
                                Text(
                                  widget.item["bizCertificationDate"] ?? "",
                                  style: WitCommonTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Row 아래에 빈 공간 추가
            Container(
              height: 1, // 줄의 높이
              color: Colors.grey[200], // 줄의 색상
            ),
          ],
        ),
      ),
    );
  }
}






