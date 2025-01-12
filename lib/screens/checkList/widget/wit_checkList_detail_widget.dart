import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/util/wit_code_ut.dart';

/**
 * 체크리스트 상세 화면 UI
 */
class CheckListDetailView extends StatefulWidget {
  final String inspNm;
  final List<dynamic> checkListByLv2;
  final List<dynamic> checkListByLv3;
  final TabController tabController;
  final Function(String) onTabChanged;
  final Function(dynamic, String) onSwitchChanged;

  const CheckListDetailView({
    Key? key,
    required this.inspNm,
    required this.checkListByLv2,
    required this.checkListByLv3,
    required this.tabController,
    required this.onTabChanged,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  _CheckListDetailViewState createState() => _CheckListDetailViewState();
}

class _CheckListDetailViewState extends State<CheckListDetailView> {
  int? expandedIndex = 0; // 클릭된 항목의 인덱스를 저장
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // ScrollController 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TabBarWidget(
              checkListByLv2: widget.checkListByLv2,
              tabController: widget.tabController,
              onTabChanged: (inspId) {
                setState(() {
                  expandedIndex = 0;
                });
                widget.onTabChanged(inspId);
              },
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.checkListByLv3.length,
                itemBuilder: (context, index) {
                  bool isExpanded = expandedIndex == index;
                  return ExpandableItem(
                    inspNm: widget.checkListByLv3[index]["inspNm"],
                    inspComt: widget.checkListByLv3[index]["inspComt"] ?? "",
                    checkYn: widget.checkListByLv3[index]["checkYn"],
                    isExpanded: isExpanded,
                    onSwitchChanged: (value) {
                      setState(() {
                        widget.checkListByLv3[index]["checkYn"] = value ? "N" : "Y";
                      });
                      widget.onSwitchChanged(widget.checkListByLv3[index], value ? "N" : "Y");
                    },
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                        if (!isExpanded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              (index - 1) * 82.5,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/**
 * 체크리스트 상세 TabBar Widget
 */
class TabBarWidget extends StatelessWidget {
  final List<dynamic> checkListByLv2;
  final TabController tabController;
  final Function(String) onTabChanged;

  const TabBarWidget({
    Key? key,
    required this.checkListByLv2,
    required this.tabController,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (checkListByLv2.isNotEmpty) {
      return Container(
        color: Colors.white,
        child: TabBar(
          controller: tabController,
          isScrollable: false,
          onTap: (index) {
            onTabChanged(checkListByLv2[index]["inspId"]);
          },
          tabs: checkListByLv2.map((item) {
            return Tab(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  item["inspNm"] + " (" + (item["checkCnt"] ?? 0).toString() + ")",
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return SizedBox.shrink(); // 리스트가 비어있을 경우 빈 위젯 반환
    }
  }
}

/**
 * 체크리스트 상세 TabBar 상세 Widget
 */
class ExpandableItem extends StatelessWidget {
  final String inspNm;
  final String inspComt;
  final String checkYn;
  final bool isExpanded;
  final Function(bool) onSwitchChanged;
  final VoidCallback onTap;

  const ExpandableItem({
    Key? key,
    required this.inspNm,
    required this.inspComt,
    required this.checkYn,
    required this.isExpanded,
    required this.onSwitchChanged,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 설정
        borderRadius: BorderRadius.circular(10), // 라운드 처리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 그림자 색상 및 투명도
            offset: Offset(0, 1), // 그림자의 위치
            blurRadius: 4, // 흐림 정도
            spreadRadius: 2, // 그림자의 퍼짐 정도
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap, // 클릭 이벤트 처리
            child: Container(
              height: 70, // 높이 70 설정
              width: double.infinity, // 가로로 가득 차게 설정
              padding: EdgeInsets.all(10), // 내부 여백 설정
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 설정 (필요에 따라 변경)
                borderRadius: BorderRadius.circular(10), // 라운드 처리 (필요에 따라 변경)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isExpanded ? Colors.blue : Colors.black,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      inspNm,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.5,
                    child: Switch(
                      value: checkYn == "N" || checkYn == "D",
                      onChanged: onSwitchChanged,
                      activeTrackColor: checkYn == "D" ? Colors.grey[400] : Colors.blue[200],
                      inactiveTrackColor: Colors.red[200],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            height: isExpanded ? 500 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 20),
                  Container(
                    height: 300,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, imageIndex) {
                        final imageUrlList = [
                          apiUrl + "/WIT/66b83d90-6dde-46f5-9005-2cfdf615bdfc5292261861812877321.jpg", // 첫 번째 이미지
                          apiUrl + "/WIT/66b83d90-6dde-46f5-9005-2cfdf615bdfc5292261861812877321.jpg", // 첫 번째 이미지
                          apiUrl + "/WIT/66b83d90-6dde-46f5-9005-2cfdf615bdfc5292261861812877321.jpg", // 첫 번째 이미지
                          apiUrl + "/WIT/66b83d90-6dde-46f5-9005-2cfdf615bdfc5292261861812877321.jpg", // 첫 번째 이미지
                          apiUrl + "/WIT/66b83d90-6dde-46f5-9005-2cfdf615bdfc5292261861812877321.jpg", // 첫 번째 이미지
                        ];
                        return Container(
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrlList[imageIndex]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 120,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    child: Text(inspComt,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Container(height: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return ExamplePhotoPopup(); // 팝업 호출
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10), // 아래 왼쪽 모서리 둥글게
                          bottomRight: Radius.circular(10), // 아래 오른쪽 모서리 둥글게
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                          children: [
                            Icon(
                              Icons.comment, // 원하는 아이콘으로 변경 가능
                              color: Colors.white, // 아이콘 색상
                            ),
                            SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                            Text(
                              "COMMENT / 하자 작성",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamplePhotoPopup extends StatefulWidget {
  @override
  _ExamplePhotoPopupState createState() => _ExamplePhotoPopupState();
}

class _ExamplePhotoPopupState extends State<ExamplePhotoPopup> {
  String text = "";
  String? imagePath;
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  @override
  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      // 다이얼로그가 열리면 TextField에 포커스를 줌
      FocusScope.of(context).requestFocus(_focusNode);
    });*/
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        height: 50, // 높이 설정
        width: double.infinity, // 좌우 가득 차게 설정
        decoration: BoxDecoration(
          color: Colors.grey, // 원하는 배경색 설정
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // 위쪽 모서리 둥글게
        ),
        alignment: Alignment.center, // 중앙 정렬
        child: Text(
          "하자 작성", // 제목 텍스트
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // 텍스트 스타일
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              children: [
                Text(
                  "하자 작성일자",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  print("선택된 날짜: ${selectedDate.toLocal()}");
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '날짜 선택',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            Container(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "COMMENT 작성",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(height: 10),
            Container(
              height: 150,
              width: 350,
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 기본 테두리 색상
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 비활성화 상태 테두리 색상
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 활성화 상태 테두리 색상
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (value) {
                  text = value;
                },
                maxLines: 5,
                style: TextStyle(height: 1.5),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "이미지 등록 (최대 3건)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    // 왼쪽 이미지 등록 로직
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // 중앙 이미지 등록 로직
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // 오른쪽 이미지 등록 로직
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Container(
          height: 50, // 버튼 높이
          width: double.infinity, // 전체 너비
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[200], // 취소 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 라운드 없애기
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10), // 간격 조정
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[200], // 확인 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 라운드 없애기
                    ),
                  ),
                  onPressed: () {
                    // 저장 로직
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text("저장",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}
