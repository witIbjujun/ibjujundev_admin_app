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
        isCertificateHolderYes = false;  // 활성화
        isCertificateHolderRe = false;  // 활성화
        isCertificateHolderNo = false;  // 활성화

        // 사업자번호 인증완료 (02)
      } else if (widget.itemInfo["bizCertification"] == "02") {
        isCertificateHolderYes = false; // 활성화
        isCertificateHolderRe = false;  // 활성화
        isCertificateHolderNo = false;  // 활성화

        // 사업자 인증완료
      } else if (widget.itemInfo["bizCertification"] == "03") {
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
      body: Container( // Container 추가
        color: Colors.white, // 배경색을 흰색으로 설정
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
                        children: [
                          buildDetailRow("대표자명", widget.itemInfo["ceoName"] ?? "", true),
                          buildDetailRow("개업일자", formatDate(widget.itemInfo["openDate"] ?? ""), true),
                          buildDetailRow("사업자번호", widget.itemInfo["storeCode"], true),
                          buildDetailRow("사업자명", widget.itemInfo["storeName"] ?? "", false),
                          buildDetailRow("대표 이메일", widget.itemInfo["email"] ?? "", false),
                          buildDetailRow("담당자 연락처", formatPhoneNumber(widget.itemInfo["hp"] ?? ""), false),
                          buildDetailRow("사업장 주소", "${widget.itemInfo["zipCode"] ?? ""}" + ") " + "${widget.itemInfo["address1"]}", false),
                          buildDetailRow("품목명", widget.itemInfo["categoryNm"] ?? "", false),
                          buildDetailRow("AS여부", widget.itemInfo["asGbnNm"] ?? "", false),
                          buildDetailRow("사업자 인증 상태", widget.itemInfo["bizCertificationNm"] ?? "", false),
                          buildDetailRow("협력업체 인증 상태", widget.itemInfo["certificationNm"] ?? "", false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ImageListDisplay(imageList: imageList),
              ActionButtonWidget(
                isCertificateHolderYes: isCertificateHolderYes,
                isCertificateHolderRe: isCertificateHolderRe,
                isCertificateHolderNo: isCertificateHolderNo,
                updateBizCertification: checkBizNo,
              ),
              SizedBox(height: 5),
            ],
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
      "bizKey": widget.itemInfo["sllrNo"],
    });

    final _imageList = await sendPostRequest(restId, param);

    // _imageList에서 bizCd가 'SR01' 또는 'SR02'인 항목만 필터링
    final filteredImageList = _imageList.where((item) => item["bizCd"] == 'SR01' || item["bizCd"] == 'SR02').toList();

    // 결과 셋팅
    setState(() {
      imageList = filteredImageList;
    });
    
  }

  // [서비스] 사업자 인증
  Future<void> checkBizNo(String biz) async {

    if (biz == "03") {

      // PARAM
      final param = jsonEncode({
        "businesses" : [{
          "b_no" : "8922900486",
          "start_dt" : "20171122",
          "p_nm" : "조성훈"
          //"b_no" : widget.itemInfo["storeCode"],
          //"start_dt" : widget.itemInfo["openDate"],
          //"p_nm" : widget.itemInfo["ceoName"]

        }]
      });

      // API 호출 (사업자 인증 요청 업체 조회)
      final result = await sendPostRequestByBizCd(param);

      if (result["status_code"] == "OK") {

        var obj = result["data"][0];

        if (obj["valid"] == "01") {
          updateBizCertification(biz);
        }
        bizInfoDialog.show(context, obj);
      } else {

        var obj = result["data"][0];
        bizInfoDialog.show(context, obj);
      }

    } else {
      updateBizCertification(biz);
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

        if (biz != "03") {
          alertDialog.show(context: context, title:"알림", content: "인증 상태를 변경 하였습니다.");
        }

        setState(() {

          // 요청중 (01)
          if (biz == "01") {
            isCertificateHolderYes = false;  // 활성화
            isCertificateHolderRe = false;  // 활성화
            isCertificateHolderNo = false;  // 활성화

            // 사업자번호 인증완료 (02)
          } else if (biz == "02") {
            isCertificateHolderYes = false; // 활성화
            isCertificateHolderRe = false;  // 활성화
            isCertificateHolderNo = false;  // 활성화

            // 사업자 인증완료
          } else if (biz == "03") {
            widget.itemInfo["bizCertificationNm"] = "사업자 인증완료 (관리자)";
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

            if (biz == "04") {
              widget.itemInfo["bizCertificationNm"] = "재인증요청";
            } else if (biz == "05") {
              widget.itemInfo["bizCertificationNm"] = "불량업체";
            }

            isCertificateHolderYes = true;  // 비활성화
            isCertificateHolderRe = true;   // 비활성화
            isCertificateHolderNo = true;   // 비활성화
          }

          widget.itemInfo["bizCertification"] = biz;

        });

      } else {
        alertDialog.show(context: context, title:"알림", content: "처리 실패되었습니다.");
      }

    });

  }
}

