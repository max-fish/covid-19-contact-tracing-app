import 'package:intl/intl.dart';

class DateUtils{
  static String get currentYearMonthDay {
    final DateTime date = DateTime.now();
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }
}