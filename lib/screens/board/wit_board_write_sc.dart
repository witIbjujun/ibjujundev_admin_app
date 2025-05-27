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
  // 별점 상태 변수 (0: 선택 안됨, 1~5: 선택된 별점)
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
    return InkWell( // 탭 감지를 위해 InkWell 사용
      onTap: () {
        setState(() {
          starRating = starIndex + 1; // 탭한 별 인덱스에 1을 더하여 별점 설정
        });
      },
      child: Icon(
        Icons.star, // 별 아이콘
        color: starRating > starIndex ? WitCommonTheme.wit_lightYellow : WitCommonTheme.wit_lightgray, // 선택된 별보다 작거나 같으면 노란색, 아니면 회색
        size: 60.0, // 별 크기
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
        child: SingleChildScrollView( // 화면 전체 스크롤을 위해 Column을 SingleChildScrollView로 감쌉니다.
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
                    maxLines: null, // 자동 조절
                    minLines: 15,
                    keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), // 패딩 10 설정
        child: Column( // 세로로 위젯을 배치하기 위해 Column 사용
          mainAxisSize: MainAxisSize.min, // Column의 크기를 자식들의 크기에 맞게 최소화
          crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼이 가로로 꽉 차도록 스트레치
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              children: [
                GestureDetector(
                  onTap: () => _showImagePickerOptions(),
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: WitCommonTheme.wit_white,
                      border: Border.all(width: 1, color: WitCommonTheme.wit_lightgray),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.add_a_photo, size: 40, color: WitCommonTheme.wit_gray), // 사진기 아이콘
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(width: 15), // GestureDetector와 이미지 리스트 간격 추가
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // 첫 번째 이미지 리스트
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
                                        width: 85,
                                        height: 85,
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
                        // 두 번째 이미지 URL 리스트
                        // 이미지 URL 리스트
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
                                        width: 85,
                                        height: 85,
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
                                            widget.imageList!.remove(item); // URL 이미지 삭제
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false, // 배경 클릭으로 닫히지 않도록 설정
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(), // 프로그래스 바
                    );
                  },
                );
                await saveImages();
                Navigator.of(context).pop(); // 프로그래스 바 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: WitCommonTheme.wit_lightBlue, // 옅은 녹색 배경
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("작성", style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white)),
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
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickMultiImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((xfile) => File(xfile.path)).toList());
      });
    }
  }
}
