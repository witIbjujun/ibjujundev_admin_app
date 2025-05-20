import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/certificateholdermanage/widget/wit_certificateholdermanage_main_widget.dart';
import 'package:ibjujundev_admin_app/util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';
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
  // 선택한 신고 상태값
  String? selectReportStat = "";

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

    final Map<String, String> _functionOptionsMap = {
      '': '전체',
      '01': '요청중',
      '02': '인증완료',
      '03': '인증완료(관리자)',
      '04': '재등록요청',
      '05': '불가처리',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key, // 코드 값 ('1', '2' 등)을 value로 사용
        child: Text(entry.value), // 표시 텍스트 ("처리 요청" 등)를 child로 사용
      );
    }).toList();

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
        child: Column( // 여러 위젯을 세로로 배열하기 위해 Column 추가
          children: [
            Container(
              color: WitCommonTheme.wit_white, // 배경색을 흰색으로 설정
              child: Padding( // 추가하려는 DropdownButton 부분 시작
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
                      value: selectReportStat,
                      items: _dropdownItems,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectReportStat = newValue;
                            getCertificateHolderList();
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
            ), // 추가하려는 구분선 부분 끝
            Expanded( // 남은 공간을 차지하도록 Expanded 추가
              child: certificateHolderList.isEmpty
                  ? Center(
                child: Text(
                  "조회된 데이터가 없습니다.",
                  style: WitCommonTheme.title,
                ),
              )
                  : CertificateHolderListView(
                certificateHolderList: certificateHolderList,
                getList: getCertificateHolderList, // 메서드의 참조를 전달
              ),
            ),
          ],
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
      "storeName" : searchController.text,
      "bizCertification" : selectReportStat
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
