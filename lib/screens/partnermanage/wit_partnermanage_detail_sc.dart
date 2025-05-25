import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/partnermanage/widget/wit_partnermanage_detail_widget.dart';

import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';
import '../common/widget/wit_common_util.dart';
import '../common/widget/wit_common_widget.dart';

/**
 * 협력업체 인증관리 상세
 */
class PartnerManageDetail extends StatefulWidget {

  final dynamic itemInfo;

  // 생성자
  const PartnerManageDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PartnerManageDetailState();
  }
}

/**
 * 협력업체 인증관리 상세 UI
 */
class PartnerManageDetailState extends State<PartnerManageDetail> {

  List<dynamic> imageList = [];
  
  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    getSellerImageList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WitCommonTheme.wit_black,
        iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
        title: Text("협력업체 인증 상세",
          style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
        ),
      ),
      body: SafeArea( // SafeArea로 감싸기
        child: SingleChildScrollView( // 스크롤 가능하게 만들기
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
                children: [
                  partnerDetailRow("사업자명", widget.itemInfo["storeName"] ?? ""),
                  partnerDetailRow("대표자명", widget.itemInfo["name"] ?? ""),
                  partnerDetailRow("대표 이메일", widget.itemInfo["email"] ?? ""),
                  partnerDetailRow("담당자 연락처", formatPhoneNumber(widget.itemInfo["hp"] ?? "")),
                  partnerDetailRow("사업장 주소", "${widget.itemInfo["zipCode"] + ") " + widget.itemInfo["address1"]+ widget.itemInfo["address2"]}"),
                  partnerDetailRow("개업일자", formatDate(widget.itemInfo["openDate"] ?? "")),
                  partnerDetailRow("사업자번호", "${widget.itemInfo["storeCode"] + "  " + widget.itemInfo["bizCertificationNm"]}"),
                  partnerDetailRow("품목명", widget.itemInfo["categoryNm"] ?? ""),
                  partnerDetailRow("AS여부", widget.itemInfo["asGbnNm"] ?? ""),
                  partnerDetailRow("인증상태", widget.itemInfo["certificationNm"] ?? ""),
                  ImageListDisplay(imageList: imageList),
                  partnerButtonWidget(
                    itemInfo : widget.itemInfo,
                    updatePartnerYn: updatePartnerYn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // [서비스] 판매자 상세 이미지 조회
  Future<void> getSellerImageList() async {
    // REST ID
    String restId = "getSellerDetailImageList";

    // PARAM
    final param = jsonEncode({
      "bizCd": "SR01",
      "bizKey": widget.itemInfo["sllrNo"],
    });

    final _imageList = await sendPostRequest(restId, param);

    print(_imageList);

    // 결과 셋팅
    setState(() {
      imageList = _imageList;
    });

  }

  // [서비스] 협력업체 인증 상태 변경
  Future<void> updatePartnerYn(String certificationYn) async {

    // REST ID
    String restId = "updatePartnerYn";

    // PARAM
    final param = jsonEncode({
      "sllrNo" : widget.itemInfo["sllrNo"],
      "certificationYn" : certificationYn
    });

    // API 호출 (협력업체 인증 상태 변경)
    final result = await sendPostRequest(restId, param);

    if (result > 0) {
      setState(() {
        if (widget.itemInfo["certificationYn"] == "N") {
          widget.itemInfo["certificationYn"] = "Y";
          widget.itemInfo["certificationNm"] = "협력업체 인증";

          alertDialog.show(context: context, title: "알림", content: "인증 완료 처리 되었습니다.");
        } else {
          widget.itemInfo["certificationYn"] = "N";
          widget.itemInfo["certificationNm"] = "협력업체 미인증";
          alertDialog.show(context: context, title: "알림", content: "인증 취소 처리 되었습니다.");
        }
      });
    } else {
      alertDialog.show(context: context, title: "알림", content: "처리 실패되었습니다.");
    }
  }
}