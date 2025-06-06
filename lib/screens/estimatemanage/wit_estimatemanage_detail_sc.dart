import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/widget/wit_estimatemanage_detail_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';

import '../common/widget/wit_common_theme.dart';

/**
 * 업체별 상태별 견적 리스트 UI
 */
class EstimateInfoDetail extends StatefulWidget {
  final dynamic itemInfo;

  // 생성자
  const EstimateInfoDetail({super.key, required this.itemInfo});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return EstimateInfoDetailState();
  }
}

/**
 * 업체별 상태별 견적 리스트 UI
 */
class EstimateInfoDetailState extends State<EstimateInfoDetail> {
  // 업체별 견적 리스트
  List<dynamic> estimateList = [];
  // 드랍박스 선택한 상태값
  String dropBoxSelectStat = "";
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();

    getEstimateInfoDetailList();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {

    final Map<String, String> _functionOptionsMap = {
      "": '전체',
      "10": '신청중',
      "20": '견적받음',
      "30": '대화중',
      "40": '진행요청',
      "50": '작업진행',
      "60": '작업완료',
      "70": '최종완료',
      "99": '착업취소',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WitCommonTheme.wit_black,
        iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
        title: Text("업체별 상세 견적 [ " + widget.itemInfo["storeName"] + " ]",
          style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: WitCommonTheme.wit_white, // 배경색을 흰색으로 설정
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
                            getEstimateInfoDetailList();
                          });
                        }
                      },
                      style: WitCommonTheme.subtitle,
                    ),
                  ),
                ),
              ),
            ),
            Container( // 추가하려는 구분선 부분 시작
              height: 1,
              color: WitCommonTheme.wit_lightgray,
            ),
            Expanded( // 남은 공간을 차지하도록 Expanded 추가
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
                child: EstimateListView(
                  estimateList: estimateList,
                  getList: getEstimateInfoDetailList,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  // [서비스] 업체별 견적 리스트 조회
  Future<void> getEstimateInfoDetailList() async {

    // REST ID
    String restId = "getEstimateRequestList";

    // PARAM
    final param = jsonEncode({
      "sllrNo": widget.itemInfo["sllrNo"],
      "stat": dropBoxSelectStat,
    });

    // API 호출 (사업자 인증 요청 업체 조회)
    final _estimateInfoDetailList = await sendPostRequest(restId, param);

    print(widget.itemInfo["sllrNo"]);
    print(dropBoxSelectStat);
    print(_estimateInfoDetailList);

    // 결과 셋팅
    setState(() {
      estimateList = _estimateInfoDetailList;  // 견적 요청 데이터

      print(estimateList.length);

      if (estimateList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }
    });
  }
}
