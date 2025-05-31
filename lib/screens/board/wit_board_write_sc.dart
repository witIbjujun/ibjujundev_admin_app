import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/wit_api_ut.dart';
import '../../util/wit_code_ut.dart';
import '../common/widget/wit_common_theme.dart';
import '../common/widget/wit_common_widget.dart';

class BoardWrite extends StatefulWidget {

  final dynamic? boardInfo;
  final List<dynamic>? imageList;
  final String bordNo;
  final String bordType;
  final String bordKey;

  const BoardWrite({super.key, this.boardInfo, this.imageList, required this.bordNo, required this.bordType, this.bordKey = ""});

  @override
  _BoardWriteState createState() => _BoardWriteState();
}

class _BoardWriteState extends State<BoardWrite> {

  List<File> _images = [];
  List<String> fileDelInfo = [];
  // 게시판 구분
  String bordTypeGbn = "";

  // 제목
  final TextEditingController _titleController = TextEditingController();
  // 내용
  final TextEditingController _contentController = TextEditingController();
  // 이미지 picker
  final ImagePicker _picker = ImagePicker();
  // 별점 상태 변수
  int starRating = 0;

  @override
  void initState() {
    super.initState();

    // 게시판 타입 앞 2자리 추출
    setState(() {
      bordTypeGbn = widget.bordType.substring(0, 2);
    });

    // boardInfo가 있을 경우 제목과 내용 설정
    if (widget.boardInfo != null) {
      _titleController.text = widget.boardInfo['bordTitle'] ?? '';
      _contentController.text = widget.boardInfo['bordContent'] ?? '';
    }
  }

  // 별 아이콘을 생성하는 위젯
  Widget _buildStar(int starIndex) {
    return InkWell(
      onTap: () {
        setState(() {
          starRating = starIndex + 1; // 탭한 별 인덱스에 1을 더하여 별점 설정
        });
      },
      child: Icon(
        Icons.star,
        color: starRating > starIndex ? WitCommonTheme.wit_lightYellow : WitCommonTheme.wit_lightgray,
        size: 60.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항 작성", style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white)),
        iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
        backgroundColor: WitCommonTheme.wit_black,
      ),
      backgroundColor: WitCommonTheme.wit_white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "제목",
                        style: WitCommonTheme.title,
                      ),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "제목을 입력하세요",
                          hintStyle: WitCommonTheme.subtitle.copyWith(color: WitCommonTheme.wit_lightgray),
                        ),
                        style: WitCommonTheme.subtitle,
                        maxLines: 1,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: WitCommonTheme.wit_extraLightGrey,
                      ),
                      SizedBox(height: 10),
                      Text("내용", style: WitCommonTheme.title),
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "내용을 입력하세요",
                          hintStyle: WitCommonTheme.subtitle.copyWith(color: WitCommonTheme.wit_lightgray),
                        ),
                        style: WitCommonTheme.subtitle,
                        maxLines: null,
                        minLines: 15,
                        keyboardType: TextInputType.multiline,
                      ),
                      // 스크롤 콘텐츠 마지막 부분과 버튼 사이에 여백 추가
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding( // 버튼 주변에 가로 패딩 적용 및 상하 여백 추가
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_images.length >= 5) {
                        alertDialog.show(context: context, title:"알림", content: "이미지는 최대 5건\n입력 가능합니다.");
                        return;
                      }
                      _showImagePickerOptions();
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: WitCommonTheme.wit_white,
                        border: Border.all(width: 1, color: WitCommonTheme.wit_lightgray),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_a_photo, size: 30, color: WitCommonTheme.wit_gray),
                          SizedBox(height: 4),
                          Text(
                            '${_images.length}/5',
                            style: WitCommonTheme.subtitle,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_images.isNotEmpty) ...[
                            Row(
                              children: _images.asMap().entries.map((entry) {
                                int index = entry.key;
                                var image = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.file(
                                          image,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: -7,
                                        top: -7,
                                        child: IconButton(
                                          icon: Icon(Icons.close, color: WitCommonTheme.wit_red),
                                          onPressed: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          if (widget.imageList != null && widget.imageList!.isNotEmpty) ...[
                            Row(
                              children: widget.imageList!.map((item) {
                                var image = apiUrl + item["imagePath"];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.network(
                                          image,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: -7,
                                        top: -7,
                                        child: IconButton(
                                          icon: Icon(Icons.close, color: WitCommonTheme.wit_red),
                                          onPressed: () {
                                            setState(() {
                                              fileDelInfo.add(item["imagePath"]);
                                              widget.imageList!.remove(item);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding( // 버튼 주변에 가로 패딩 적용 및 상하 여백 추가
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: SizedBox( // 버튼을 좌우 가득 채우도록 설정
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await saveImages();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WitCommonTheme.wit_lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("작성", style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // [서비스] 이미지 저장
  Future<void> saveImages() async {

    // 제목 입력 체크
    if (_titleController.text.trim().isEmpty) {
      alertDialog.show(context: context, title:"알림", content: "제목을 입력해주세요.");
      return;
    }

    // 내용 입력 체크
    if (_contentController.text.trim().isEmpty) {
      alertDialog.show(context: context, title:"알림", content: "내용을 입력해주세요.");
      return;
    }

    await Future.delayed(Duration(milliseconds: 500));

    // 이미지 확인
    if (_images.isEmpty) {
      saveBoardInfo(null);
    } else {
      final fileInfo = await sendFilePostRequest("fileUpload", _images);
      if (fileInfo == "FAIL") {
        alertDialog.show(context: context, title:"오류", content: "파일 업로드 실패하였습니다.");
      } else {
        saveBoardInfo(fileInfo);
      }
    }
  }

  // [서비스] 게시판 저장
  Future<void> saveBoardInfo(dynamic fileInfo) async {

    String restId = "";
    var param;

    if (widget.boardInfo == null) {
      restId = "saveBoardInfo";
      param = jsonEncode({
        "bordTitle": _titleController.text,
        "bordContent": _contentController.text,
        "bordKey": widget.bordKey,
        "bordType": widget.bordType,
        "starRating": starRating,
        "creUser": "99999",
        "fileInfo": fileInfo
      });

    } else {
      restId = "updateBoardInfo";
      param = jsonEncode({
        "bordTitle": _titleController.text,
        "bordContent": _contentController.text,
        "bordNo" : widget.boardInfo["bordNo"],
        "bordKey": widget.boardInfo["bordKey"],
        "bordType": widget.boardInfo["bordType"],
        "creUser": "99999",
        "updUser": "99999",
        "fileInfo": fileInfo,
        "fileDelInfo": fileDelInfo,
        "starRating": starRating,
      });
    }

    final result = await sendPostRequest(restId, param);

    if (result != null) {
      Navigator.pop(context);
      alertDialog.show(context: context, title:"알림", content: "공지사항 등록 되었습니다.");
      
    } else {
      Navigator.pop(context);
      alertDialog.show(context: context, title:"오류", content: "공지사항 등록 실패되었습니다.");
    }
  }

  // [팝업] 갤러리, 카메라 팝업 호출
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('갤러리에서 선택'),
                onTap: () {
                  _pickMultiImages();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('사진 찍기'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (_images.length < 5) {
          _images.add(File(pickedFile.path));
        }
      });
    }
  }

  Future<void> _pickMultiImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        for (final xfile in pickedFiles) {
          if (_images.length < 5) {
            _images.add(File(xfile.path));
          }
        }
      });
    }
  }
}
