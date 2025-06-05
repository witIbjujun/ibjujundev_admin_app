import 'package:flutter/material.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/widget/wit_common_widget.dart';
import '../../common/wit_ImageViewer_sc.dart';

// 타이틀 및 수정/삭제 영역
class TitleAndMenu extends StatelessWidget {
  final Map<String, dynamic> communityDetailInfo;

  TitleAndMenu({
    required this.communityDetailInfo,
  });

  @override
  Widget build(BuildContext context) {

    String bordTypeGbn = communityDetailInfo["bordType"].substring(0, 2);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (bordTypeGbn == "UH")...[
          Expanded(
            child: Text(
              "업체 후기",
              style: WitCommonTheme.title,
            ),
          ),
        ] else... [
          Expanded(
            child: Text(
              communityDetailInfo["bordTitle"] ?? "",
              style: WitCommonTheme.title,
            ),
          ),
        ]
        
        
      ],
    );
  }
}

// 유저 영역
class UserInfo extends StatelessWidget {
  final Map<String, dynamic> communityDetailInfo;

  UserInfo({
    required this.communityDetailInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: proFlieImage.getImageProvider(communityDetailInfo["profileImg"] ?? ""),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${communityDetailInfo["creUserNm"] ?? "익명"}",
              style: WitCommonTheme.subtitle,
            ),
            Row(
              children: [
                Text(
                  '${communityDetailInfo["creDateTxt"] ?? ""}',
                  style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                ),
                SizedBox(width: 8),
                Text(
                  '조회 ${communityDetailInfo["bordRdCnt"] ?? 0}',
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
  final List<dynamic> communityDetailImageList;

  ImageListDisplay({
    required this.communityDetailImageList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: communityDetailImageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideRoute(page: ImageViewer(
                  imageUrls: communityDetailImageList.map((item) => apiUrl + item["imagePath"]).toList(),
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
                  image: NetworkImage(apiUrl + communityDetailImageList[index]["imagePath"]),
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

// 신고 건수 영역
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

// 신고 리스트 영역
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
        return Container( // 네모 박스로 감싸기 위해 Container 추가
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0), // 박스 간의 세로 간격 추가
          padding: EdgeInsets.all(10.0), // 박스 내부 여백 추가
          decoration: BoxDecoration(
            color: WitCommonTheme.wit_extraLightGrey,
            borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 만들기 (반경 8.0)
          ),
          child: ListTile(
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
                      // 원래 Divider는 Container 밖으로 이동하거나 필요에 따라 조정 가능
                      // Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}