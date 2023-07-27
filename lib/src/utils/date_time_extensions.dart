import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateFormat get dayMonthYear => DateFormat('dd.MM.yyyy');

  String toFormattedString() {
    return dayMonthYear.format(this);
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get beginingOfCurrentMonth => DateTime(year, month);

  DateTime getMonthsAgo(int months) {
    return DateTime(year, month - months);
  }
}
