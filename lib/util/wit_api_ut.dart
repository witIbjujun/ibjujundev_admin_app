import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ibjujundev_admin_app/util/wit_code_ut.dart';

/**
 * POST 방식 통신
 * @param restId
 * @param Json
 * @return dynamic
 */
Future<dynamic> sendPostRequest(String restId, dynamic param) async {

  Uri uri = Uri.parse(apiUrl + "/wit/" + restId);

  // Head
  final headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // API 호출
  final response = await http.post(uri, headers : headers, body : param ?? "");

  // 호출 성공
  if (response.statusCode == 200) {
    // 성공적으로 데이터를 전송했을 때의 처리
    return json.decode(utf8.decode(response.bodyBytes));

    // 호출 실패
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');

  }

}

/**
 * POST 방식 통신
 * 사업자번호 인증 확인 API
 * @param Json
 * @return dynamic
 */
Future<dynamic> sendPostRequestByBizCd(dynamic param) async {

  Uri uri = Uri.parse("https://api.odcloud.kr/api/nts-businessman/v1/validate?serviceKey=" + serviceKey);

  final headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // API 호출
  final response = await http.post(uri, headers : headers, body : param ?? "");
  // 호출 성공
  if (response.statusCode == 200) {
    // 성공적으로 데이터를 전송했을 때의 처리
    return json.decode(utf8.decode(response.bodyBytes));

    // 호출 실패
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');

  }

}