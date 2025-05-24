import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_theme.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import 'package:ibjujundev_admin_app/screens/certificateholdermanage/widget/wit_certificateholdermanage_detail_widget.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_util.dart';

/**
 * 사업자 인증 상세 화면
 */
class CertificateHolderDetail extends StatefulWidget {
  final dynamic itemInfo;

  // 생성자
  const CertificateHolderDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return CertificateHolderDetailState();
  }
}

/**
 * 사업자 인증 상세 화면 UI
 */
class CertificateHolderDetailState extends State<CertificateHolderDetail> {

  bool isBizNo = false;
  bool isCertificateHolderYes = false;
  bool isCertificateHolderRe = false;
  bool isCertificateHolderNo = false;
  List<dynamic> imageList = [];

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    setState(() {

      // 요청중 (01)
      if (widget.itemInfo["bizCertification"] == "01") {
        isBizNo = false;                // 활성화
        isCertificateHolderYes = true;  // 비활성화
        isCertificateHolderRe = false;  // 활성화
        isCertificateHolderNo = false;  // 활성화

        // 사업자번호 인증완료 (02)
      } else if (widget.itemInfo["bizCertification"] == "02") {
        isBizNo = true;                 // 비활성화
        isCertificateHolderYes = false; // 활성화
        isCertificateHolderRe = false;  // 활성화
        isCertificateHolderNo = false;  // 활성화

        // 사업자 인증완료
      } else if (widget.itemInfo["bizCertification"] == "03") {
        isBizNo = true;                 // 비활성화
        isCertificateHolderYes = true;  // 비활성화

        if (widget.itemInfo["certificationYn"] == "Y") {
          isCertificateHolderRe = true;  // 비활성화
          isCertificateHolderNo = true;  // 비활성화
        } else {
          isCertificateHolderRe = false;  // 활성화
          isCertificateHolderNo = false;  // 활성화
        }

        // 재등록 요청 (04), 불가처리 (05)
      } else if (widget.itemInfo["bizCertification"] == "04" || widget.itemInfo["bizCertification"] == "05") {
        isBizNo = true;                 // 비활성화
        isCertificateHolderYes = true;  // 비활성화
        isCertificateHolderRe = true;   // 비활성화
        isCertificateHolderNo = true;   // 비활성화
      }

    });

    // 판매자 이미지 조회
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
        title: Text("사업자 인증 상세",
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
                  buildDetailRow("사업자명", widget.itemInfo["storeName"] ?? "", false),
                  buildDetailRow("대표자명", widget.itemInfo["name"] ?? "", true),
                  buildDetailRow("대표 이메일", widget.itemInfo["email"] ?? "", false),
                  buildDetailRow("담당자 연락처", formatPhoneNumber(widget.itemInfo["hp"] ?? ""), false),
                  buildDetailRow("사업장 주소", widget.itemInfo["zipCode"] ?? "" + ") " + widget.itemInfo["address1"] ?? "", false),
                  buildDetailRow("개업일자", formatDate(widget.itemInfo["openDate"] ?? ""), true),
                  buildDetailRow("사업자번호",
                      widget.itemInfo["storeCode"] + "   " + widget.itemInfo["bizCertificationNm"], true,
                    action: ElevatedButton(
                      onPressed: isBizNo ? null : () {
                        // 사업자 번호 인증
                        checkBizNo(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WitCommonTheme.wit_lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      ),
                      child: widget.itemInfo["bizCertification"] == "01"
                          ? Text("인증대기")
                          : widget.itemInfo["bizCertification"] == "02"
                          ? Text("인증확인")
                          : widget.itemInfo["bizCertification"] == "03"
                          ? Text("인증확인")
                          : widget.itemInfo["bizCertification"] == "04"
                          ? Text("재등록요청")
                          : widget.itemInfo["bizCertification"] == "05"
                          ? Text("인증실패")
                          : Text("상태 없음"),
                    )),
                  buildDetailRow("품목명", widget.itemInfo["categoryNm"] ?? "", false),
                  buildDetailRow("AS여부", widget.itemInfo["asGbnNm"] ?? "", false),
                  buildDetailRow("인증상태", widget.itemInfo["certificationNm"] ?? "", false),
                  ImageListDisplay(imageList: imageList),
                  ActionButtonWidget(
                    isCertificateHolderYes: isCertificateHolderYes,
                    isCertificateHolderRe: isCertificateHolderRe,
                    isCertificateHolderNo: isCertificateHolderNo,
                    updateBizCertification: updateBizCertification,
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

    // 결과 셋팅
    setState(() {
      imageList = _imageList;
    });
    
  }

  // [서비스] 사업자 인증
  Future<void> checkBizNo(BuildContext context) async {

    // PARAM
    final param = jsonEncode({
      "businesses" : [{
        //"b_no" : "8922900486",
        //"start_dt" : "20171122",
        //"p_nm" : "조성훈"
        "b_no" : widget.itemInfo["storeCode"],
        "start_dt" : widget.itemInfo["openDate"],
        "p_nm" : widget.itemInfo["name"]

      }]
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final result = await sendPostRequestByBizCd(param);

    if (result["status_code"] == "OK") {

      var obj = result["data"][0];

      // 사업자번호 정상이면
      if (obj["valid"] == "01") {
        setState(() {
          isBizNo = true;
          isCertificateHolderYes = false;
        });

        updateBizCertification("02");
      }

      bizInfoDialog.show(context, obj);

    // 사업자번호 인증 실패
    } else {
      var obj = {};
      obj["b_no"] = widget.itemInfo["storeCode"];
      obj["tax_type"] = "사업자번호 인증 실패";

      bizInfoDialog.show(context, obj);
    }
  }

  // [서비스] 사업자 인증 상태 변경
  Future<void> updateBizCertification(String biz) async {

    // REST ID
    String restId = "updateBizCertification";

    // PARAM
    final param = jsonEncode({
      "sllrNo" : widget.itemInfo["sllrNo"],
      "bizCertification" : biz
    });

    // API 호출 (사업자 인증 상태 변경)
    final result = await sendPostRequest(restId, param);

    setState(() {

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("처리 되었습니다.")));

        setState(() {

          // 요청중 (01)
          if (biz == "01") {
            isBizNo = false;                // 활성화
            isCertificateHolderYes = true;  // 비활성화
            isCertificateHolderRe = false;  // 활성화
            isCertificateHolderNo = false;  // 활성화

            // 사업자번호 인증완료 (02)
          } else if (biz == "02") {
            isBizNo = true;                 // 비활성화
            isCertificateHolderYes = false; // 활성화
            isCertificateHolderRe = false;  // 활성화
            isCertificateHolderNo = false;  // 활성화

            // 사업자 인증완료
          } else if (biz == "03") {
            isBizNo = true;                 // 비활성화
            isCertificateHolderYes = true;  // 비활성화
            if (widget.itemInfo["certificationYn"] == "Y") {
              isCertificateHolderRe = true;  // 비활성화
              isCertificateHolderNo = true;  // 비활성화
            } else {
              isCertificateHolderRe = false;  // 활성화
              isCertificateHolderNo = false;  // 활성화
            }
            // 재등록 요청 (04), 불가처리 (05)
          } else if (biz == "04" || biz == "05") {
            isBizNo = true;                 // 비활성화
            isCertificateHolderYes = true;  // 비활성화
            isCertificateHolderRe = true;   // 비활성화
            isCertificateHolderNo = true;   // 비활성화
          }

          widget.itemInfo["bizCertification"] = biz;

        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("처리 실패되었습니다.")));
      }

    });

  }
}

