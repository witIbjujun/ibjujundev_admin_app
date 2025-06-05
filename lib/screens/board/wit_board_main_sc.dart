import 'dart:convert';
import 'package:flutter/material.dart';
import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';
import '../common/widget/wit_common_widget.dart';
import '../board/widget/wit_board_main_widget.dart';
import '../board/wit_board_write_sc.dart';

// 게시판 메인
class Board extends StatefulWidget {

  final String bordType;    // CM0X : 커뮤니티, UH0X : 업체후기, JU0X : 자유게시판, GJ0X : 공지사항
  final String bordKey;     // 공용KEY

  const Board({super.key, required this.bordType, this.bordKey = ""});

  @override
  State<StatefulWidget> createState() {
    return BoardState();
  }
}

class BoardState extends State<Board> {

  // 게시판 리스트
  List<dynamic> boardList = [];
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
  // 게시판 구분
  String bordTypeGbn = "";
  // 빈데이터 화면 출력여부
  bool emptyDataFlag = false;
  // 드랍박스 선택한 상태값
  String dropBoxSelectStat = "GJ01";

  /**
   * 초기로딩
   */
  @override
  void initState() {
    super.initState();

    // 게시판 타입 앞 2자리 추출
    setState(() {
      bordTypeGbn = widget.bordType.substring(0, 2);
    });
    
    // 스크롤 이벤트 추가
    scrollController.addListener(_onScroll);

    // 게시판 리스트 조회
    currentPage = 1;
    boardList = [];
    getBoardList("init");
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
    getBoardList("init");
  }

  /**
   * [이벤트] 필터 검색
   */
  void filterList() {
    // 필터 검색
    getBoardList("init");
  }

  /**
   * 화면 생성
   */
  @override
  Widget build(BuildContext context) {

    final Map<String, String> _functionOptionsMap = {
      "GJ01": '전체 공지사항',
      "GJ02": '사용자 공지사항',
      "GJ03": '판매자 공지사항',
    };

    final List<DropdownMenuItem<String>> _dropdownItems = _functionOptionsMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();

    return Scaffold(
      appBar: SearchAppBar(
        appBarTitle: "공지사항",
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
                            getBoardList("init");
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
            Expanded(
              child: Scrollbar(
                child: Container(
                  color: WitCommonTheme.wit_white,
                  child: BoardListView(
                    boardList: boardList,
                    refreshBoardList: refreshBoardList,
                    scrollController: scrollController,  // ScrollController 연결
                    bordTitle: "공지사항",
                    bordTypeGbn: bordTypeGbn,
                    emptyDataFlag: emptyDataFlag,
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
      // FloatingActionButton을 조건에 따라 표시하는 부분
      floatingActionButton: Container( // 조건이 참일 때 표시할 위젯
        width: 60, // 원하는 너비
        height: 60, // 원하는 높이
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              SlideRoute(page: BoardWrite(bordNo: ""
                  , bordType: dropBoxSelectStat
                  , bordKey: widget.bordKey)),
            );
            await refreshBoardList();
          },
          backgroundColor: WitCommonTheme.wit_black,
          shape: CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_note,
                color: WitCommonTheme.wit_white,
                size: 35,
              )
            ],
          ),
        ),
      ),
    );
  }

  // [서비스] 게시판 리스트 조회
  Future<void> getBoardList(String searchGbn) async {

    if (isLoading) return; // 이미 로딩 중이면 무시

    setState(() {
      isLoading = true;
    });

    if (searchGbn == "init") {
      currentPage = 1;
      boardList = [];
    }

    // REST ID
    String restId = "getBoardList";

    // PARAM
    final param = jsonEncode({
      "bordType": dropBoxSelectStat,
      "searchText" : searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });


    // API 호출 (게시판 리스트 조회)
    final _boardList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardList.addAll(_boardList);
      currentPage++; // 페이지 증가
      isLoading = false;

      if (boardList.isEmpty) {
        emptyDataFlag = true;
      } else {
        emptyDataFlag = false;
      }

    });
  }

  // [서비스] 게시판 리스트 새로고침
  Future<void> refreshBoardList() async {

    currentPage = 1;
    boardList = [];

    // REST ID
    String restId = "getBoardList";

    // PARAM
    final param = jsonEncode({
      "bordType": dropBoxSelectStat,
      "searchText" : searchController.text.trim(),
      "currentPage": (currentPage - 1) * pageSize,
      "pageSize": pageSize,
    });


    // API 호출 (게시판 리스트 조회)
    final _boardList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardList.addAll(_boardList);
      currentPage++; // 페이지 증가
      isLoading = false;

      if (boardList.isEmpty) {
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
      getBoardList("add");
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
