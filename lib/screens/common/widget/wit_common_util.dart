import 'dart:io';
import 'package:image/image.dart' as img;

/**
 * [유틸] 폰번호 포맷
 */
String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length == 11) {
    return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
  }
  return phoneNumber;
}

/**
 * [유틸] 날짜 포맷
 */
String formatDate(String date) {
  if (date == null || date == "") {
    return "";
  }
  DateTime parsedDate = DateTime.parse(date);
  String year = parsedDate.year.toString();
  String month = parsedDate.month.toString().padLeft(2, '0'); // 01, 02 형태로
  String day = parsedDate.day.toString().padLeft(2, '0'); // 01, 02 형태로
  return '$year년 $month월 $day일'; // 형식화된 문자열 반환
}

String? formatDateYYYYMMDD(DateTime? date) {
  if (date == null || date == "") {
    return "";
  }
  return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
}

/**
 * [유틸] 금액 포맷
 */
String formatCash(String cash) {
  // 문자열을 숫자로 변환하고 쉼표를 추가
  String buffer = '';
  int length = cash.length;

  for (int i = 0; i < length; i++) {
    buffer += cash[i];
    // 뒤에서부터 3자리마다 쉼표 추가
    if ((length - i - 1) % 3 == 0 && (length - i - 1) != 0) {
      buffer += ',';
    }
  }

  return buffer;
}

/**
 * [유틸] 이미지 파일 압축
 * 800 X 600 사이즈로
 */
Future<File> compressImage(File file) async {
  // 파일을 바이트로 읽기
  final bytes = await file.readAsBytes();

  // 이미지 디코딩
  img.Image? image = img.decodeImage(bytes);

  image = img.copyResize(
    image!,
    width: 800,
    height: 800,
    // interpolation: img.Interpolation.linear, // 필요에 따라 보간 방식 지정 가능
  );

  // 압축된 이미지를 파일로 저장 (사이즈 조절 없이 압축만 수행)
  final compressedFile = File(file.path);
  await compressedFile.writeAsBytes(img.encodeJpg(image!, quality: 50)); // quality: 0~100

  return compressedFile;
}