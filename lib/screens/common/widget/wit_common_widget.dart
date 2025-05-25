import 'package:flutter/cupertino.dart';
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
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    Color confirmColor = Colors.blue,
    Color cancelColor = Colors.grey,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,  // 🔹 글씨 크기 키움
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,  // 🔹 글씨 크기 키움
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(false); // 🚫 취소 시 false 반환
              },
              child: Text(
                cancelText,
                style: TextStyle(color: cancelColor),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(true); // ✅ 확인 시 true 반환
              },
              child: Text(
                confirmText,
                style: TextStyle(color: confirmColor),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false; // 결과가 null이면 false 반환
  }
}

/*******************************
 * [이벤트] 알림 팝업 호출
 ******************************/
class alertDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    Color confirmColor = CupertinoColors.activeBlue,
    VoidCallback? onConfirm,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // 바깥 클릭으로 닫히지 않음
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // 창 닫기
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              child: Text(
                confirmText,
                style: TextStyle(color: confirmColor),
              ),
            ),
          ],
        );
      },
    );
  }
}