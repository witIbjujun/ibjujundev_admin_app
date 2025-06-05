import 'package:flutter/material.dart';
import '../../common/widget/wit_common_widget.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../../util/wit_code_ut.dart';
import '../wit_partnermanage_detail_sc.dart';

/**
 * 협력업체 인증관리 리스트 뷰
 */
class PartnerListView extends StatelessWidget {
  final List<dynamic> partnerList;
  final Future<void> Function() getList;

  const PartnerListView({
    required this.partnerList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: partnerList.length,
      itemBuilder: (context, index) {
        final item = partnerList[index];
        return PartnerCard(
          item: item,
          onTap: () async {
            await Navigator.push(
              context,
              SlideRoute(page: PartnerManageDetail(itemInfo: item)),
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
 * 협력업체 인증관리 카드
 */
class PartnerCard extends StatefulWidget {

  final dynamic item;
  final VoidCallback onTap;

  const PartnerCard({required this.item, required this.onTap});

  @override
  _PartnerCardState createState() => _PartnerCardState();
}

class _PartnerCardState extends State<PartnerCard> {

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
                    if (widget.item["storeImage"] != null) ...[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: WitCommonTheme.wit_gray.withOpacity(0.5),
                            width: 1,
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
                                  child: Text("협력업체 여부",
                                    style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_black),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("${widget.item["certificationNm"] ?? "협력업체 미인증"}",
                                    style: WitCommonTheme.caption
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 1,
              color:WitCommonTheme.wit_extraLightGrey,
            ),
          ],
        ),
      ),
    );
  }
}






