import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/widget/wit_pointmanage_main_widget.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

/**
 * 포인트 관리 메인
 */
class PointManage extends StatefulWidget {

  // 생성자
  const PointManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PointManageState();
  }
}

/**
 * 포인트 관리 메인 UI
 */
class PointManageState extends State<PointManage> {

  // 포인트 정보 리스트
  List<dynamic> pointInfoList = [];
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

    // 포인트 정보 조회
    getPointInfoList();
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
    getPointInfoList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getPointInfoList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "포인트 관리",
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
        child: pointInfoList.isEmpty
            ? Center(
          child: Text(
            "조회된 데이터가 없습니다.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : PointInfoListView(
          pointInfoList: pointInfoList,
          getList: getPointInfoList, // 메서드의 참조를 전달
        ),
      ),
    );
  }

  // [서비스] 포인트 정보 조회
  Future<void> getPointInfoList() async {

    // 데이터 초기화
    pointInfoList = [];

    // REST ID
    String restId = "getPointInfoList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final _pointInfoList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      pointInfoList.addAll(_pointInfoList);
    });
  }
}