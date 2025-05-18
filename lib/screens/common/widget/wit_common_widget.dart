import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_theme.dart';

/*******************************
 * [위젯] 검색 앱바
 ******************************/
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchSubmit;

  const SearchAppBar({
    required this.appBarTitle,
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: WitCommonTheme.wit_black,
      iconTheme: IconThemeData(color: WitCommonTheme.wit_white),
      title: isSearching ?
      TextField(
        controller: searchController,
        onSubmitted: (value) {
          onSearchSubmit(value);
        },
        decoration: InputDecoration(
          hintText: "업체명을 입력해주세요...",
          filled: true,
          fillColor: WitCommonTheme.wit_white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ),
      ) : Text(appBarTitle,
        style: WitCommonTheme.title.copyWith(color: WitCommonTheme.wit_white),
      ),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search, color: WitCommonTheme.wit_white,),
          onPressed: onSearchToggle,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/*******************************
 * [이벤트] 화면 전환
 ******************************/
class SlideRoute extends PageRouteBuilder {
  final Widget page;

  SlideRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

/*******************************
 * [이벤트] 컨펌 팝업 호출
 ******************************/
class ConfirmationDialog {
  static void show(BuildContext context, String message, Future<void> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("확인",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          content: Text(message,
            style: TextStyle(fontSize: 12),
          ), // 메시지를 파라미터로 받음
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                onConfirm().then((_) {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                });
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}

/*******************************
 * [이벤트] 알림 팝업 호출
 ******************************/
class alertDialog {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("확인",
                style: TextStyle(fontSize: 12)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}