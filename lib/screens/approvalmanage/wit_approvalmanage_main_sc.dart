import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/approvalmanage/widget/wit_approvalmanage_main_widget.dart';

/**
 * 결재내역 조회 메인
 */
class ApprovalManage extends StatefulWidget {

  // 생성자
  const ApprovalManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return ApprovalManageState();
  }
}

/**
 * 결재내역 조회 메인 UI
 */
class ApprovalManageState extends State<ApprovalManage> {

  // 포인트 정보 리스트
  List<dynamic> approvalInfoList = [];
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

    // 결재내역 조회
    getApprovalInfoList();
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
    getApprovalInfoList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getApprovalInfoList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "결재내역 조회",
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
        child: approvalInfoList.isEmpty
            ? Center(
          child: Text(
            "조회된 데이터가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : ApprovalInfoListView(
          approvalInfoList: approvalInfoList,
          getList: getApprovalInfoList, // 메서드의 참조를 전달
        ),
      ),
    );
  }

  // [서비스] 결재내역 조회
  Future<void> getApprovalInfoList() async {

    // 데이터 초기화
    approvalInfoList = [];

    // REST ID
    String restId = "getApprovalInfoList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text
    });

    // API 호출 (결재내역 조회)
    //final _approvalInfoList = await sendPostRequest(restId, param);

    List<dynamic>  _approvalInfoList = [
      {"approvalGbn":"01", "approvalNm":"카카오페이 충전", "approvalNo":"P2024120000223", "approvalAmt":"300000", "sendResult":"정상", "resultTime":"2024년 12월 23일 18:12:21"},
      {"approvalGbn":"01", "approvalNm":"카카오페이 충전", "approvalNo":"P2024120000223", "approvalAmt":"400000", "sendResult":"정상", "resultTime":"2024년 12월 23일 18:12:21"},
      {"approvalGbn":"01", "approvalNm":"카카오페이 충전", "approvalNo":"P2024120000223", "approvalAmt":"500000", "sendResult":"정상", "resultTime":"2024년 12월 23일 18:12:21"}
    ];

    // 결과 셋팅
    setState(() {
      approvalInfoList.addAll(_approvalInfoList);
    });
  }
}