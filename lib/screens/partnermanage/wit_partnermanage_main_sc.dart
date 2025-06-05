import 'dart:convert';

import 'package:flutter/material.dart';
import '../partnermanage/widget/wit_partnermanage_main_widget.dart';
import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';
import '../common/widget/wit_common_widget.dart';

/**
 * 협력업체 인증관리 메인
 */
class PartnerManage extends StatefulWidget {

  // 생성자
  const PartnerManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PartnerManageState();
  }
}

/**
 * 협력업체 인증관리 메인 UI
 */
class PartnerManageState extends State<PartnerManage> {

  // 협력업체 리스트
  List<dynamic> partnerList = [];
  // 검색 활성화 여부
  bool isSearching = false;
  // TextEdit 컨트롤러
  TextEditingController searchController = TextEditingController();
  // 드랍박스 선택한 상태값
  String? dropBoxSelectStat = "";
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    // 협력업체 인증 내역 조회
    getPartnerList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {

    final Map<String, String> _functionOptionsMap = {
      "": '전체',
      "N": '협력업체 미인증',
      "Y": '협력업체 인증',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();

    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "협력업체 인증 관리",
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
        child: Column(
          children: [
            Container(
              color: WitCommonTheme.wit_white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: WitCommonTheme.wit_white,
                      value: dropBoxSelectStat,
                      items: _dropdownItems,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropBoxSelectStat = newValue;
                            // 협력업체 인증 내역 조회
                            getPartnerList();
                          });
                        }
                      },
                      style: WitCommonTheme.subtitle,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              color: WitCommonTheme.wit_lightgray,
            ),
            Expanded(
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
                  child: PartnerListView(
                  partnerList: partnerList,
                  getList: getPartnerList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [서비스] 협력업체 인증 내역 조회
  Future<void> getPartnerList() async {

    // 데이터 초기화
    partnerList = [];

    // REST ID
    String restId = "getSellerList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text,
      "bizCertification" : "03",
      "certificationYn" : dropBoxSelectStat,
    });

    // API 호출 (협력업체 인증 내역 조회)
    final _partnerList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      partnerList.addAll(_partnerList);

      if (_partnerList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }

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
    getPartnerList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getPartnerList();
  }
}