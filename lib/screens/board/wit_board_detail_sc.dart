import 'dart:convert';
import 'package:flutter/material.dart';

import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';
import '../board/widget/wit_board_detail_widget.dart';
import '../common/widget/wit_common_widget.dart';

dynamic boardDetailInfo = {};
String boardTitle = "";


List<dynamic> boardDetailImageList = [];

List<dynamic> commentList = [];

class BoardDetail extends StatefulWidget {

  final dynamic param;
  final String bordTitle;

  const BoardDetail({super.key, required this.param, required this.bordTitle});

  @override
  State<StatefulWidget> createState() {
    boardDetailInfo = this.param;
    boardTitle = this.bordTitle;
    return BoardDetailState();
  }
}

class BoardDetailState extends State<BoardDetail> {
  TextEditingController commentController = TextEditingController();

  String loginClerkNo = "99999";
  // 게시판 구분
  String bordTypeGbn = "";

  @override
  void initState() {
    super.initState();

    // 게시판 타입 앞 2자리 추출
    setState(() {
      bordTypeGbn = widget.param["bordType"].substring(0, 2);
    });

    // 게시판 조회수 증가
    boardRdCntUp();

    // 게시판 상세 조회
    getBoardDetailList();

    // 게시판 상세 이미지 조회
    getBoardDetailImageList();

    // 댓글 리스트 조회
    getCommentList();
  }

  void reSearch() {

    // 게시판 상세 조회
    getBoardDetailList();

    // 게시판 상세 이미지 조회
    getBoardDetailImageList();

    // 댓글 리스트 조회
    getCommentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardTitle, style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white)),
        iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
        backgroundColor: WitCommonTheme.wit_black,
      ),
      backgroundColor: WitCommonTheme.wit_white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndMenu(
                        boardDetailInfo: boardDetailInfo,
                        boardDetailImageList: boardDetailImageList,
                        endBoardInfo: endBoardInfo,
                        context: context,
                        loginClerkNo : loginClerkNo,
                        callBack: reSearch,
                        bordKeyGbn: bordTypeGbn,
                      ),
                      SizedBox(height: 20),
                      UserInfo(
                        boardDetailInfo: boardDetailInfo,
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 1,
                        color: WitCommonTheme.wit_extraLightGrey,
                      ),
                      SizedBox(height: 20),
                      ContentDisplay(
                        content: boardDetailInfo["bordContent"] ?? "",
                        imgCnt: boardDetailImageList.length,
                      ),
                      if (boardDetailImageList.length > 0)...[
                        ImageListDisplay(
                          boardDetailImageList: boardDetailImageList,
                        ),
                        SizedBox(height: 20),
                      ] else ...[],
                      if (bordTypeGbn != "UH" && bordTypeGbn != "GJ")...[
                        Container(
                          height: 1,
                          color: WitCommonTheme.wit_extraLightGrey,
                        ),
                        SizedBox(height: 20),
                        CommentCount(
                          count: commentList.length,
                        ),

                        SizedBox(height: 5),
                        CommentList(
                          commentList: commentList,
                          loginClerkNo : loginClerkNo,
                          endCommentInfo : endCommentInfo,
                        ),
                        CommentInput(
                          commentController: commentController,
                          saveCommentInfo: saveCommentInfo,
                          isEmpty: commentList.isEmpty,
                        ),
                      ],
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

  // [서비스] 게시판 조회수 증가
  Future<void> boardRdCntUp() async {

    // REST ID
    String restId = "boardRdCntUp";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      boardDetailInfo["bordRdCnt"] = boardDetailInfo["bordRdCnt"] + 1;
    });
  }

  // [서비스] 게시판 상세 조회
  Future<void> getBoardDetailList() async {

    // REST ID
    String restId = "getBoardDetailInfo";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "creUser": loginClerkNo,
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

  // [서비스] 댓글 리스트 조회
  Future<void> getCommentList() async {

    // REST ID
    String restId = "getCommentList";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "bordType": boardDetailInfo["bordType"],
    });

    // API 호출 (게시판 상세 조회)
    final _commentList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      commentList = _commentList;
    });
  }

  // 댓글 저장
  Future<void> saveCommentInfo() async {

    String cmmtContent = commentController.text;

    // 댓글 내용이 비어있지 않은 경우에만 추가
    if (cmmtContent.isNotEmpty) {
      // REST ID
      String restId = "saveCommentInfo";

      // PARAM
      final param = jsonEncode({
        "bordNo": boardDetailInfo["bordNo"],
        "bordType": boardDetailInfo["bordType"],
        "cmmtContent": cmmtContent,
        "creUser": loginClerkNo,
      });

      // API 호출 (댓글 추가)
      final _commentList = await sendPostRequest(restId, param);

      // 댓글 리스트 갱신
      setState(() {
        commentList = _commentList;
        commentController.clear();
      });
    }
  }

  // [서비스] 게시판 종료
  Future<void> endBoardInfo() async {
    // REST ID
    String restId = "endBoardInfo";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "updUser": loginClerkNo,
    });

    // API 호출 (게시판 상세 조회)
    final result = await sendPostRequest(restId, param);

    if (result > 0) {
      Navigator.of(context).pop(true);
      alertDialog.show(context: context, title:"알림", content: "삭제 되었습니다.");
    } else {
      alertDialog.show(context: context, title:"알림", content: "삭제 실패 되었습니다.");
    }

  }
  
  // 댓글 삭제
  Future<void> endCommentInfo(dynamic data) async {

    // REST ID
    String restId = "endCommentInfo";

    // PARAM
    final param = jsonEncode({
      "bordNo": boardDetailInfo["bordNo"],
      "cmmtNo": data["cmmtNo"],
      "updUser" : loginClerkNo,
    });

    // API 호출 (댓글 추가)
    final endResult = await sendPostRequest(restId, param);

    // 댓글 리스트 갱신
    setState(() {
      if (endResult > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 삭제 되었습니다.')),
        );
        getCommentList();
      }
    });
  }
}
