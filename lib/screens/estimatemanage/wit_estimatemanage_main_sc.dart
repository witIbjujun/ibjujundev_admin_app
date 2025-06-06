import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/widget/wit_estimatemanage_main_widget.dart';

import '../common/widget/wit_common_theme.dart';

/**
 * 견적요청 리스트 메인 UI
 */
class EstimateManage extends StatefulWidget {

  // 생성자
  const EstimateManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return EstimateManageState();
  }
}

/**
 * 견적요청 리스트 메인 UI
 */
class EstimateManageState extends State<EstimateManage> {

  // 견적요청 정보 리스트
  List<dynamic> estimateInfoList = [];
  // 검색 활성화 여부
  bool isSearching = false;
  // TextEdit 컨트롤러
  TextEditingController searchController = TextEditingController();
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    estimateInfoList = [];
    isSearching = false;
    emptyDataFlag = false;

    // 견적요청 정보 조회
    getEstimateInfoList();
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
    getEstimateInfoList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getEstimateInfoList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "업체별 견적 요청",
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
        child: emptyDataFlag
            ? Container(
          color: WitCommonTheme.wit_white,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 48,
                  color: WitCommonTheme.wit_lightgray,
                ),
                SizedBox(height: 16),
                Text(
                  "조회된 값이 없습니다",
                  style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_black),
                ),
              ],
            ),
          ),
        ) : Container(
          color: WitCommonTheme.wit_white,
          child : EstimateInfoListView(
            estimateInfoList: estimateInfoList,
            getList: getEstimateInfoList, // 메서드의 참조를 전달
          ),
        ),
      ),
    );
  }

  // [서비스] 견적요청 정보 조회
  Future<void> getEstimateInfoList() async {

    // 데이터 초기화
    estimateInfoList = [];

    // REST ID
    String restId = "getEstimateCntList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text
    });

    // API 호출 (업체별 견적요청 정보 조회)
    final _estimateInfoList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      estimateInfoList.addAll(_estimateInfoList);

      if (estimateInfoList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }
    });
  }
}