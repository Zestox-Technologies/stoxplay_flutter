import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_urls.dart';

final Dio _dio = Dio();

Future<DateTime?> getCurrentTime() async {
  try {
    final response = await _dio.get(ApiUrls.liveServerTime);
    print("object");
    if (response.statusCode == 200) {
      final data = response.data;
      final dateTimeString = data['dateTime'] as String?;
      if (dateTimeString != null) {
        return DateTime.parse(dateTimeString);
      }
    }
  } catch (e) {
    print('Error fetching time: $e');
  }
  return  null;
}
