import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/certificateholdermanage/widget/wit_certificateholdermanage_main_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

import '../common/widget/wit_common_widget.dart';

/**
 * 사업자 인증 요청 내역 메인
 */
class CertificateHolderManage extends StatefulWidget {

  // 생성자
  const CertificateHolderManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return CertificateHolderManageState();
  }
}

/**
 * 사업자 인증 요청 내역 메인 UI
 */
class CertificateHolderManageState extends State<CertificateHolderManage> {

  // 사업자 인증 요청 내역 리스트
  List<dynamic> certificateHolderList = [];
  // 검색 활성화 여부
  bool isSearching = false;
  // TextEdit 컨트롤러
  TextEditingController searchController = TextEditingController();

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    // 사업자 인증 요청 내역 조회
    getCertificateHolderList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "사업자 인증 요청 내역",
        isSearching: isSearching,
        searchController: searchController,
        onSearchToggle: () {
          if (isSearching) {
            stopSearch();
          } else {
            startSearch();
          }
        },
        onSearchSubmit: (value) => filterList(),
      ),
      body: SafeArea(
        child: certificateHolderList.isEmpty
            ? Center(
          child: Text(
            "조회된 데이터가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : CertificateHolderListView(
          certificateHolderList: certificateHolderList,
          getList: getCertificateHolderList, // 메서드의 참조를 전달
        ),
      ),
    );
  }


  // [서비스] 사업자 인증 요청 업체 조회
  Future<void> getCertificateHolderList() async {

    // 데이터 초기화
    certificateHolderList = [];

    // REST ID
    String restId = "getSellerList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final _certificateHolderList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      certificateHolderList.addAll(_certificateHolderList);
    });
  }

  /**
   * [이벤트] 검색 기능 활성화
   */
  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  /**
   * [이벤트] 검색 기능 비활성화
   */
  void stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
    });
    // 검색 완료시 필터 제거
    getCertificateHolderList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getCertificateHolderList();
  }

}
