import 'package:flutter/material.dart';

import '../../../util/wit_code_ut.dart';
import '../../common/widget/wit_common_theme.dart';
import '../../common/widget/wit_common_widget.dart';
import '../../common/wit_ImageViewer_sc.dart';
import '../wit_board_write_sc.dart';

// 타이틀 및 수정/삭제 영역
class TitleAndMenu extends StatelessWidget {
  final Map<String, dynamic> boardDetailInfo;
  final List<dynamic> boardDetailImageList;
  final Function endBoardInfo;
  final BuildContext context;
  final String loginClerkNo;
  final Function callBack;
  final String bordKeyGbn;

  TitleAndMenu({
    required this.boardDetailInfo,
    required this.boardDetailImageList,
    required this.endBoardInfo,
    required this.context,
    required String this.loginClerkNo,
    required this.callBack,
    required this.bordKeyGbn,
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
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: WitCommonTheme.wit_gray),
          color: WitCommonTheme.wit_white,
          onSelected: (value) async {
            if (value == 'edit') {
              await Navigator.push(
                context,
                SlideRoute(page: BoardWrite(
                  boardInfo: boardDetailInfo,
                  imageList: boardDetailImageList,
                  bordNo: boardDetailInfo["bordNo"] ?? "",
                  bordType: boardDetailInfo["bordType"],
                  bordKey: boardDetailInfo["bordKey"] ?? "",
                )),
              ).then((_) {
                callBack();
              });
            } else if (value == 'delete') {
              bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"삭제하시겠습니까?");
              if (isConfirmed == true) {
                endBoardInfo();
              }
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: WitCommonTheme.wit_lightBlue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '수정하기',
                      style: WitCommonTheme.caption,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: WitCommonTheme.wit_lightBlue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '삭제하기',
                      style: WitCommonTheme.caption,
                    ),
                  ],
                ),
              ),
            ];
          },
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
        CircleAvatar(
          radius: 20,
          backgroundImage: proFlieImage.getImageProvider(boardDetailInfo["profileImg"] ?? ""),
        ),
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
class CommentCount extends StatelessWidget {
  final int count;

  CommentCount({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "댓글 ",
          style: WitCommonTheme.subtitle,
        ),
        Text(
          count.toString(),
          style: WitCommonTheme.subtitle,
        ),
      ],
    );
  }
}

// 댓글 리스트 영역
class CommentList extends StatelessWidget {
  final List<dynamic> commentList;
  final String loginClerkNo;
  final Function endCommentInfo;

  CommentList({
    required this.commentList,
    required this.loginClerkNo,
    required this.endCommentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: commentList.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: proFlieImage.getImageProvider(commentList[index]["profileImg"] ?? ""),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      commentList[index]["cmmtContent"] ?? "",
                      style: WitCommonTheme.subtitle,
                    ),
                    SizedBox(height: 4),
                    Text(
                      (commentList[index]["creUserNm"] ?? "") + " | " + (commentList[index]["creDateTxt"] ?? ""),
                      style: WitCommonTheme.caption.copyWith(color: WitCommonTheme.wit_gray),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: WitCommonTheme.wit_gray), // 휴지통 아이콘
                onPressed: () async {
                  bool isConfirmed = await ConfirmationDialog.show(context: context, title:"확인", content:"선택하신 댓글을 삭제하시겠습니까?");
                  if (isConfirmed == true) {
                    endCommentInfo(commentList[index]);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// 댓글 입력 영역
class CommentInput extends StatelessWidget {
  final TextEditingController commentController;
  final Function saveCommentInfo;
  final bool isEmpty;

  CommentInput({
    required this.commentController,
    required this.saveCommentInfo,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: isEmpty ? "첫 댓글을 남겨보세요" : "댓글을 남겨보세요",
              border: InputBorder.none,
              filled: true,
              fillColor: WitCommonTheme.wit_white,
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: WitCommonTheme.wit_gray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(Icons.send, size: 25, color: WitCommonTheme.wit_white),
            onPressed: () => saveCommentInfo(),
            tooltip: '댓글 보내기',
          ),
        ),
      ],
    );
  }
}