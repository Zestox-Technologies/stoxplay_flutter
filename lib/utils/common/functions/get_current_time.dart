import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';

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
  return null;
}

String formatMaxWinIntl(int amount, {bool showRupeeSymbol = true}) {
  final format = NumberFormat.compactCurrency(decimalDigits: 0, symbol: showRupeeSymbol ? '₹' : '', locale: 'en_IN');
  return format.format(amount);
}

int getTotalSecondsFromTimeLeft(TimeLeft timeLeft) {
  return timeLeft.days! * 86400 + timeLeft.hours! * 3600 + timeLeft.minutes! * 60 + (timeLeft.seconds ?? 0);
}
