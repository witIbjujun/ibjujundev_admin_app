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

  Color _backgroundColor = WitCommonTheme.wit_white;

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
      onTap: widget.onTap,
      child: Container(
        color: _backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    // 이미지가 존재할 경우에만 표시
                    if (widget.item["storeImage"] != null) ...[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: WitCommonTheme.wit_gray.withOpacity(0.5),
                            width: 1, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            apiUrl + widget.item["storeImage"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                    ],
                    if (widget.item["storeImage"] == null) ...[
                      Container(
                        width: 60,
                        height: 60,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.item["storeName"],
                            style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (widget.item["certificationYn"] == "Y")
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Icon(
                                Icons.emoji_events,
                                size: 20,
                                color: Colors.amber,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: WitCommonTheme.wit_white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: WitCommonTheme.wit_gray),
                                  ),
                                  child: Text("인증여부",
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("${widget.item["bizCertificationNm"]}",
                                  style: WitCommonTheme.caption
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
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
                                Text(
                                  widget.item["bizCertificationDateOri"] ?? "",
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
            SizedBox(height: 10),
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}






