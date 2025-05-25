import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/paymentmanage/widget/wit_paymentmanage_main_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

import '../common/widget/wit_common_theme.dart';

/**
 * 결재내역 조회 메인
 */
class PaymentManage extends StatefulWidget {

  // 생성자
  const PaymentManage({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return PaymentManageState();
  }
}

/**
 * 결재내역 조회 메인 UI
 */
class PaymentManageState extends State<PaymentManage> {

  // 결재내역 리스트
  List<dynamic> paymentList = [];
  // 검색 활성화 여부
  bool isSearching = false;
  // TextEdit 컨트롤러
  TextEditingController searchController = TextEditingController();
  // 드랍박스 - 결재 방식
  String? dropBoxPayMethod = "";
  // 드랍박스 - 결재 상태
  String? dropBoxPayStat = "";
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    // 결재내역 조회
    getPaymentList();
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
    getPaymentList();
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getPaymentList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {

    final Map<String, String> _functionOptionsMap = {
      "": '결재 상태 (전체)',
      "paid": '결제 성공',
      "failed": '결제 실패',
      "ready": '결재 대기',
      "cancelled": '결재 취소',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();

    final Map<String, String> _functionOptionsMap2 = {
      "": '결재 방식 (전체)',
      "card": '카드',
      "cash": '현금',
    };


    final List<DropdownMenuItem<String>> _dropdownItems2 = _functionOptionsMap2.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();

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
        child: Column( // 여러 위젯을 세로로 배열하기 위해 Column 추가
          children: [
            Container(
              color: WitCommonTheme.wit_white, // 배경색을 흰색으로 설정
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row( // <--- 여기에 Row 위젯 추가
                  children: [
                    Expanded(
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
                            value: dropBoxPayMethod,
                            items: _dropdownItems2,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  dropBoxPayMethod = newValue;
                                  // 결재내역 리스트
                                  getPaymentList();
                                });
                              }
                            },
                            style: WitCommonTheme.subtitle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
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
                            value: dropBoxPayStat,
                            items: _dropdownItems,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  dropBoxPayStat = newValue;
                                  // 결재내역 리스트
                                  getPaymentList();
                                });
                              }
                            },
                            style: WitCommonTheme.subtitle,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                child: PaymentListView(
                  paymentList: paymentList,
                  getPaymentList: getPaymentList, // 결재내역 리스트
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [서비스] 결재내역 조회
  Future<void> getPaymentList() async {

    // 데이터 초기화
    paymentList = [];

    // REST ID
    String restId = "getSubscribePaymentDataList";

    // PARAM
    final param = jsonEncode({
      "storeName" : searchController.text,
      "payMethod" : dropBoxPayMethod,
      "status" : dropBoxPayStat,
    });

    // API 호출 (결재내역 조회)
    final _paymentList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      paymentList.addAll(_paymentList);

      if (_paymentList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }
    });
  }
}