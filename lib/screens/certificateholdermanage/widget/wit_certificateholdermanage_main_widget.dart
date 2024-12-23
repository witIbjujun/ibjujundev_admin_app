import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/certificateholdermanage/wit_certificateholdermanage_detail_sc.dart';

/**
 * 커스텀 앱바
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchSubmit;

  const CustomAppBar({
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: isSearching ?
        TextField(
          controller: searchController,
          onSubmitted: (value) {
            onSearchSubmit(value);
          },
          decoration: InputDecoration(
            hintText: "업체명을 입력해주세요...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
        ) : Text("사업자 인증 요청 내역"),
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search),
          onPressed: onSearchToggle,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/**
 * 사업자 인증 요청 리스트 뷰
 */
class CertificateHolderListView extends StatelessWidget {
  final List<dynamic> certificateHolderList;
  final Future<void> Function() getList; // 메서드 타입으로 변경

  const CertificateHolderListView({
    required this.certificateHolderList,
    required this.getList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: certificateHolderList.length,
      itemBuilder: (context, index) {
        final item = certificateHolderList[index];
        return GestureDetector(
          onTap: () async {
            // 클릭 시 CertificateHolderDetail로 화면 전환
            await Navigator.push(
              context,
              _createRoute(CertificateHolderDetail(itemInfo: item)),
            );
            // 화면 복귀 시 리스트를 새로 조회
            await getList();
          },
          child: CertificateHolderCard(item: item),
        );
      },
    );
  }

  /*******************************
   * [이벤트] 화면 전환
   ******************************/
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
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
}

/**
 * 사업자 인증 요청 카드
 */
class CertificateHolderCard extends StatelessWidget {

  final dynamic item;

  const CertificateHolderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                item["storeName"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(
                "(${item["bizCertificationNm"]})",
                style: item["bizCertification"] == "01"
                    ? TextStyle(fontSize: 16, color: Colors.green)
                    : item["bizCertification"] == "02"
                    ? TextStyle(fontSize: 16, color: Colors.green)
                    : item["bizCertification"] == "03"
                    ? TextStyle(fontSize: 16, color: Colors.blue)
                    : item["bizCertification"] == "04"
                    ? TextStyle(fontSize: 16, color: Colors.orange)
                    : item["bizCertification"] == "05"
                    ? TextStyle(fontSize: 16, color: Colors.red)
                    : TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
          ),
          Text(
            item["bizCertificationDate"],
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}