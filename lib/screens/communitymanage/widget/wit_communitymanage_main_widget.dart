import 'package:flutter/material.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/widget/wit_common_widget.dart';
import '../wit_communitymanage_detail_sc.dart';

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function refreshCommunityList;
  final String bordTitle;

  CustomSearchAppBar({
    required this.searchController,
    required this.refreshCommunityList,
    required this.bordTitle,
  });

  @override
  _CustomSearchAppBarState createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (!_isSearching) {
      widget.searchController.clear();
      widget.refreshCommunityList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
      backgroundColor: WitCommonTheme.wit_black,
      title: _isSearching
          ? TextField(
        controller: widget.searchController,
        autofocus: true,
        style: WitCommonTheme.subtitle.copyWith(color: WitCommonTheme.wit_white),
        decoration: InputDecoration(
          hintText: "검색어를 입력해주세요",
          hintStyle: WitCommonTheme.subtitle.copyWith(color: WitCommonTheme.wit_white),
          border: InputBorder.none,
        ),
        onSubmitted: (String value) {
          widget.refreshCommunityList();
        },
      )
          : Text(
        (widget.bordTitle.isNotEmpty) ? widget.bordTitle : "게시판",
        style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          color: WitCommonTheme.wit_white,
          onPressed: () {
            if (_isSearching) {
              if (widget.searchController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림', style: WitCommonTheme.title),
                      content: Text('검색어를 입력해 주세요.', style: WitCommonTheme.subtitle),
                      actions: [
                        TextButton(
                          child: Text('확인'),
                          onPressed: () {
                            Navigator.of(context).pop(); // 알림창 닫기
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                // 검색 버튼 클릭 시 동작
                widget.refreshCommunityList();
              }
            } else {
              // 검색 모드로 전환
              _toggleSearch();
            }
          },
        ),
        if (_isSearching)
          IconButton(
            icon: Icon(
              Icons.clear,
              color: WitCommonTheme.wit_white,
            ),
            onPressed: _toggleSearch, // 검색 취소
          ),
      ],
    );
  }
}

class CommunityListView extends StatelessWidget {
  final List<dynamic> communityList;
  final Function refreshCommunityList;
  final ScrollController scrollController;
  final bool emptyDataFlag;

  CommunityListView({
    required this.communityList,
    required this.refreshCommunityList,
    required this.scrollController,
    required this.emptyDataFlag,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: RefreshIndicator(
          onRefresh: () async {
            await refreshCommunityList();
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // 게시판 리스트
              if (emptyDataFlag == true)
                SliverToBoxAdapter(
                  child: Container(
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
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final communityInfo = communityList[index];
                      return Container(
                        color: WitCommonTheme.wit_white, // 배경색을 흰색으로 설정
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              title: Row(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: (communityInfo["bordType"] == "CM01") ? WitCommonTheme.wit_lightSteelBlue : // 커뮤니티
                                                        (communityInfo["bordType"] == "JU01") ? WitCommonTheme.wit_lightCoral :   // 자유게시판
                                                        (communityInfo["bordType"] == "UH01") ? WitCommonTheme.wit_lightCoral :   // 업체후기
                                                        WitCommonTheme.wit_lightgray,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Text("${communityInfo["bordTypeNm"]}",
                                                      style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10), // 이미지 영역 뒤에 추가된 SizedBox
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        communityInfo["bordTitle"] == "" ? communityInfo["bordContent"] : communityInfo["bordTitle"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${communityInfo["creUserNm"] ?? "익명"}  |  ${communityInfo["creDateTxt"]}  |  조회 ${communityInfo["bordRdCnt"]}",
                                                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (communityInfo["imagePath"] != null && communityInfo["imagePath"] != "") ...[
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            apiUrl + communityInfo["imagePath"],
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return SizedBox(width: 0); // 오류 발생 시 빈 컨테이너
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  SizedBox(width: 10), // 이미지 영역 뒤에 추가된 SizedBox
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: WitCommonTheme.wit_extraLightGrey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Text("${communityInfo["reportCnt"]}",
                                                      style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text("신고",
                                                    style: WitCommonTheme.caption,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  SlideRoute(page: CommunityDetail(param: communityInfo)),
                                );
                                await refreshCommunityList();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                height: 1,
                                color: WitCommonTheme.wit_extraLightGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: communityList.length,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
