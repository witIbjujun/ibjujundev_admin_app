import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/communitymanage/widget/wit_communitymanage_detail_widget.dart';

import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';

dynamic boardDetailInfo = {};
List<dynamic> boardDetailImageList = [];
List<dynamic> boardReportDetailList = [];

class BoardDetail extends StatefulWidget {

  final dynamic param;

  const BoardDetail({super.key, required this.param});

  @override
  State<StatefulWidget> createState() {
    boardDetailInfo = this.param;
    return BoardDetailState();
  }
}

class BoardDetailState extends State<BoardDetail> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 게시판 상세 조회
    getBoardDetailList();

    // 게시판 상세 이미지 조회
    getBoardDetailImageList();

    // 게시판 신고 상세 조회
    getBoardReportDetailList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시판 신고 관리", style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white)),
        iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
        backgroundColor: WitCommonTheme.wit_black,
      ),
      backgroundColor: WitCommonTheme.wit_white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      TitleAndMenu(
                        boardDetailInfo: boardDetailInfo,
                      ),
                      SizedBox(height: 20),
                      UserInfo(
                        boardDetailInfo: boardDetailInfo,
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      ContentDisplay(
                        content: boardDetailInfo["bordContent"] ?? "",
                        imgCnt: boardDetailImageList.length,
                      ),
                      if (boardDetailImageList.length > 0)...[
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                        ImageListDisplay(
                          boardDetailImageList: boardDetailImageList,
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                      ] else ...[
                        Divider(),
                        SizedBox(height: 5),
                      ],
                      ReportCount(
                        count: boardReportDetailList.length,
                      ),
                      SizedBox(height: 5),
                      ReportList(
                        reportList: boardReportDetailList,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [서비스] 게시판 상세 조회
  Future<void> getBoardDetailList() async {

    // REST ID
    String restId = "getBoardDetailInfo";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    final _boardDetailInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailInfo = _boardDetailInfo;
    });
  }

  // [서비스] 게시판 상세 이미지 조회
  Future<void> getBoardDetailImageList() async {
    // REST ID
    String restId = "getBoardDetailImageList";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "bordType": boardDetailInfo["bordType"],
    });

    // API 호출 (게시판 상세 조회)
    final _boardDetailImageList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailImageList = _boardDetailImageList;
    });
  }

  // [서비스] 게시판 신고 상세 조회
  Future<void> getBoardReportDetailList() async {

    // REST ID
    String restId = "getBoardReportDetailList";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    final _BoardReportDetailList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardReportDetailList = _BoardReportDetailList;
    });
  }
}
