import 'package:flutter/material.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/widget/wit_common_widget.dart';
import '../../common/wit_ImageViewer_sc.dart';

// 타이틀 및 수정/삭제 영역
class TitleAndMenu extends StatelessWidget {
  final Map<String, dynamic> boardDetailInfo;

  TitleAndMenu({
    required this.boardDetailInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            boardDetailInfo["bordTitle"] ?? "",
            style: WitCommonTheme.title,
          ),
        ),
      ],
    );
  }
}

// 유저 영역
class UserInfo extends StatelessWidget {
  final Map<String, dynamic> boardDetailInfo;

  UserInfo({
    required this.boardDetailInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 20, backgroundColor: WitCommonTheme.wit_lightBlue),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${boardDetailInfo["creUserNm"] ?? "익명"}",
              style: WitCommonTheme.subtitle,
            ),
            Row(
              children: [
                Text(
                  '${boardDetailInfo["creDateTxt"] ?? ""}',
                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                ),
                SizedBox(width: 8),
                Text(
                  '조회 ${boardDetailInfo["bordRdCnt"] ?? 0}',
                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// 내용 영역
class ContentDisplay extends StatelessWidget {
  final String content;
  final int imgCnt;

  ContentDisplay({
    required this.content,
    required this.imgCnt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: imgCnt == 0 ? 540 : 340,
      ),
      child: Text(content,
        style: WitCommonTheme.subtitle,
      ),
    );
  }
}

// 이미지 리스트 영역
class ImageListDisplay extends StatelessWidget {
  final List<dynamic> boardDetailImageList;

  ImageListDisplay({
    required this.boardDetailImageList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: boardDetailImageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideRoute(page: ImageViewer(
                  imageUrls: boardDetailImageList.map((item) => apiUrl + item["imagePath"]).toList(),
                  initialIndex: index,
                )),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(apiUrl + boardDetailImageList[index]["imagePath"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 댓글 숫자 영역
class ReportCount extends StatelessWidget {
  final int count;

  ReportCount({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "신고 건수 ",
          style: WitCommonTheme.title,
        ),
        Text(
          count.toString() + "건",
          style: WitCommonTheme.subtitle,
        ),
      ],
    );
  }
}

// 댓글 리스트 영역
class ReportList extends StatelessWidget {
  final List<dynamic> reportList;

  ReportList({
    required this.reportList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reportList.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "신고 사유",
                      style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      reportList[index]["reportReason"] ?? "",
                      style: WitCommonTheme.subtitle,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "신고 내용",
                      style: WitCommonTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      reportList[index]["reportContent"] ?? "",
                      style: WitCommonTheme.subtitle,
                    ),
                    SizedBox(height: 4),
                    Text(
                      (reportList[index]["creUserNm"] ?? "") + " | " + (reportList[index]["creDateTxt"] ?? ""),
                      style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                    ),
                    SizedBox(height: 4),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}