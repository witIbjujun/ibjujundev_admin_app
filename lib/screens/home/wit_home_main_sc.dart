import 'package:flutter/material.dart';
import 'package:ibjujundev_admin_app/screens/CertificateHoldermanage/wit_certificateholdermanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/approvalmanage/wit_approvalmanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/communitymanage/wit_communitymanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/estimatemanage/wit_estimatemanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/joininfomanage/wit_joininfomanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/partnermanage/wit_partnermanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/pointmanage/wit_pointmanage_main_sc.dart';
import 'package:ibjujundev_admin_app/screens/common/widget/wit_common_widget.dart';

/**
 * 입주전 관리자 메인 홈
 */
class Home extends StatefulWidget {

  // 생성자
  const Home({super.key});

  // 상태 생성
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

/**
 * 입주전 관리자 메인 UI
 */
class HomeState extends State<Home> {

  /**
   * 화면 초기화
   */
  @override
  void initState() {
    super.initState();
  }

  /**
   * 화면 UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("입주전 관리자",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20), // 텍스트와 버튼 간격 조정
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 사업자 인증 요청 내역 버튼
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: CertificateHolderManage()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "사업자 인증 요청 내역",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    // 포인트 관리 버튼
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: PointManage()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "포인트 관리",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    // 커뮤니티 관리 버튼
                    ElevatedButton(
                        onPressed: null,
                      /*onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: CommunityManage()));
                      },*/
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "커뮤니티 관리",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    // 결재내역 조회 버튼
                    ElevatedButton(
                      onPressed: null,
                      /*onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: ApprovalManage()));
                      },*/
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "결재내역 조회",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    // 가입정보 정보조회 버튼
                    ElevatedButton(
                      onPressed: null,
                      /*onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: JoinInfoManage()));
                      },*/
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "가입정보 정보조회",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),

                    // 견적요청 리스트 버튼
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: EstimateManage()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "견적요청 리스트",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 20),
                    
                    // 협력업체 인증관리 버튼
                    ElevatedButton(
                      onPressed: null,
                      /*onPressed: () {
                        Navigator.of(context).push(SlideRoute(page: PartnerManage()));
                      },*/
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "협력업체 인증관리",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}