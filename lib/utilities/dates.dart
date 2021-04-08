import 'package:intl/intl.dart';

// Utility class that holds functions to get dates
class DateUtils {
  //get yesterday's date
  static String get yesterdayYearMonthDay {
    final DateTime date = DateTime.now().subtract(const Duration(days: 1));
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  //get the day before yesterday date
  static String get dayBeforeYesterdayYearMonthDay {
    final DateTime date = DateTime.now().subtract(const Duration(days: 2));
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }
}