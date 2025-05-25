import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/widget/wit_common_widget.dart';
import '../communitymanage/widget/wit_communitymanage_main_widget.dart';
import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';

// 게시판 메인
class CommunityManage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return CommunityManageState();
  }
}

class CommunityManageState extends State<CommunityManage> {

  // 게시판 리스트
  List<dynamic> communityList = [];
  // 검색 여부
  bool isSearching = false;
  // 검색 Text 컨트롤러
  TextEditingController searchController = TextEditingController();
  // 페이징 컨트롤러
  ScrollController scrollController = ScrollController();
  // 페이징 로딩 여부
  bool isLoading = false;
  // 페이징 시작 번호
  int currentPage = 1;
  // 페이징 1회 건수
  final int pageSize = 10;
  // 선택한 신고 상태값
  String? selectReportStat = "10";
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;

  /**
   * 초기로딩
   */
  @override
  void initState() {
    super.initState();

    // 스크롤 이벤트 추가
    scrollController.addListener(_onScroll);

    // 게시판 리스트 조회
    currentPage = 1;
    communityList = [];

    getCommunityReportList("init");
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
    getCommunityReportList("init");
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getCommunityReportList("init");
  }

  /**
   * 화면 생성
   */
  @override
  Widget build(BuildContext context) {

    final Map<String, String> _functionOptionsMap = {
      '10': '신고 요청',
      '20': '신고 완료',
      '30': '신고 보류',
      '40': '신고 취소',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key, // 코드 값 ('1', '2' 등)을 value로 사용
        child: Text(entry.value), // 표시 텍스트 ("처리 요청" 등)를 child로 사용
      );
    }).toList();

    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "게시판 신고 관리",
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      value: selectReportStat,
                      items: _dropdownItems,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectReportStat = newValue;
                            currentPage = 1;
                            communityList = [];
                            getCommunityReportList("init");
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
              child: Scrollbar(
                controller: scrollController,
                child: Container(
                  color: WitCommonTheme.wit_white,
                  child: CommunityListView(
                    communityList: communityList,
                    refreshCommunityList: refreshCommunityReportList,
                    scrollController: scrollController,
                    emptyDataFlag: emptyDataFlag,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [서비스] 게시판 리스트 조회
  Future<void> getCommunityReportList(String searchGbn) async {

    if (isLoading) return; // 이미 로딩 중이면 무시

    setState(() {
      isLoading = true;
    });

    if (searchGbn == "init") {
      currentPage = 1;
      communityList = [];
    }

    // REST ID
    String restId = "getBoardReportList";

    // PARAM
    final param = jsonEncode({
      "reportStat" : selectReportStat,
      "searchText" : searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });

    // API 호출 (게시판 리스트 조회)
    final _communityList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      communityList.addAll(_communityList);
      currentPage++;
      isLoading = false;

      if (communityList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }
    });
  }

  // [서비스] 게시판 리스트 새로고침
  Future<void> refreshCommunityReportList() async {

    currentPage = 1;
    communityList = [];

    // REST ID
    String restId = "getBoardReportList";

    // PARAM
    final param = jsonEncode({
      "reportStat" : selectReportStat,
      "searchText" : searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });


    // API 호출 (게시판 리스트 조회)
    final _communityList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      communityList.addAll(_communityList);
      currentPage++; // 페이지 증가
      isLoading = false;

      if (communityList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }
    });

  }

  // [이벤트] 스크롤 이벤트
  void _onScroll() {
    // 스크롤이 최하단에 도달하면 추가 데이터 로드
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      getCommunityReportList("add");
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
