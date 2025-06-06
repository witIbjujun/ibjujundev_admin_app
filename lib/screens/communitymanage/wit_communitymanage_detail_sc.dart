import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/widget/wit_common_widget.dart';
import '../communitymanage/widget/wit_communitymanage_detail_widget.dart';
import '../../util/wit_api_ut.dart';
import '../common/widget/wit_common_theme.dart';

dynamic communityDetailInfo = {};
List<dynamic> communityDetailImageList = [];
List<dynamic> communityReportDetailList = [];

class CommunityDetail extends StatefulWidget {

  final dynamic param;

  const CommunityDetail({super.key, required this.param});

  @override
  State<StatefulWidget> createState() {
    communityDetailInfo = this.param;
    return CommunityDetailState();
  }
}

class CommunityDetailState extends State<CommunityDetail> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 게시판 상세 조회
    getCommunityDetailList();

    // 게시판 상세 이미지 조회
    getCommunityDetailImageList();

    // 게시판 신고 상세 조회
    getCommunityReportDetailList();
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
                        communityDetailInfo: communityDetailInfo,
                      ),
                      SizedBox(height: 20),
                      UserInfo(
                        communityDetailInfo: communityDetailInfo,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: WitCommonTheme.wit_extraLightGrey,
                      ),
                      SizedBox(height: 10),
                      ContentDisplay(
                        content: communityDetailInfo["bordContent"] ?? "",
                        imgCnt: communityDetailImageList.length,
                      ),
                      if (communityDetailImageList.length > 0)...[
                        SizedBox(height: 10),
                        ImageListDisplay(
                          communityDetailImageList: communityDetailImageList,
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 1,
                          color: WitCommonTheme.wit_extraLightGrey,
                        ),
                        SizedBox(height: 10),
                      ] else ...[
                        Container(
                          height: 1,
                          color: WitCommonTheme.wit_extraLightGrey,
                        ),
                        SizedBox(height: 5),
                      ],
                      ReportCount(
                        count: communityReportDetailList.length,
                      ),
                      ReportList(
                        reportList: communityReportDetailList,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 하단 버튼
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 첫 번째 버튼 (예시: 처리 완료)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"신고 취소 하시겠습니까?");

                      if (isConfirmed == true) {
                        updateReportStat("신고 취소", "40");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WitCommonTheme.wit_lightGreen,
                      foregroundColor: WitCommonTheme.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text("신고 취소"), // 버튼 텍스트 변경 가능
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"신고 보류 하시겠습니까?");

                      if (isConfirmed == true) {
                        updateReportStat("신고 보류", "30");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WitCommonTheme.wit_lightGoldenrodYellow,
                      foregroundColor: WitCommonTheme.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text("신고 보류"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"신고 완료 하시겠습니까?");

                      if (isConfirmed == true) {
                        updateReportStat("블라인드 처리", "20");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WitCommonTheme.wit_red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text("블라인드 처리"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // [서비스] 게시판 상세 조회
  Future<void> getCommunityDetailList() async {

    // REST ID
    String restId = "getBoardDetailInfo";

    // PARAM
    final param = jsonEncode({
      "bordNo": communityDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    final _communityDetailInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      communityDetailInfo = _communityDetailInfo;
    });
  }

  // [서비스] 게시판 상세 이미지 조회
  Future<void> getCommunityDetailImageList() async {
    // REST ID
    String restId = "getBoardDetailImageList";

    // PARAM
    final param = jsonEncode({
      "bordNo": communityDetailInfo["bordNo"],
      "bordType": communityDetailInfo["bordType"],
    });

    // API 호출 (게시판 상세 조회)
    final _communityDetailImageList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      communityDetailImageList = _communityDetailImageList;
    });
  }

  // [서비스] 게시판 신고 상세 조회
  Future<void> getCommunityReportDetailList() async {

    // REST ID
    String restId = "getBoardReportDetailList";

    // PARAM
    final param = jsonEncode({
      "bordNo": communityDetailInfo["bordNo"],
    });

    // API 호출 (게시판 상세 조회)
    final _communityReportDetailList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      communityReportDetailList = _communityReportDetailList;
    });
  }

  // [서비스] 게시판 신고 처리
  Future<void> updateReportStat(confirmStr, stat) async {

    // REST ID
    String restId = "updateReportStat";

    // PARAM
    final param = jsonEncode({
      "bordNo": communityDetailInfo["bordNo"],
      "reportStat": stat,
    });

    // API 호출 (게시판 상세 조회)
    final result = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {

      if (result > 0) {
        Navigator.pop(context);
        alertDialog.show(context: context, title:"알림", content: confirmStr + " 처리 되었습니다.");
      } else {
        alertDialog.show(context: context, title:"알림", content: confirmStr + " 처리중 오류가 발생되었습니다.");
      }

    });
  }
}
