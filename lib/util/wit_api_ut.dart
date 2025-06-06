import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '/util/wit_code_ut.dart';
import '../screens/common/widget/wit_common_util.dart';

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

/**
 * 파일 POST 방식 통신
 * @param restId
 * @param Json
 * @return dynamic
 */
Future<dynamic> sendFilePostRequest(String restId, List<File> fileList) async {

  // Dio 인스턴스 생성
  Dio dio = Dio();

  // FormData 생성
  FormData formData = FormData();

  // 파일 리스트를 순회하면서 파일 추가
  for (var file in fileList) {

    // 압축된 파일 추가
    formData.files.add(MapEntry(
      "images", // 필드 이름
      await MultipartFile.fromFile(file.path), // MultipartFile 생성
    ));
  }

  try {
    // POST 요청
    Response response = await dio.post(apiUrl + "/wit/" + restId, data: formData);

    // 성공 응답 처리
    if (response.statusCode == 200) {
      return response.data; // 본문 데이터 반환
    } else {
      return "FAIL";
    }
  } catch (e) {
    // 예외 처리
    return "FAIL: $e";
  }
}