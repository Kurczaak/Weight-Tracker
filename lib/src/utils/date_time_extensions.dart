import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateFormat get dayMonthYear => DateFormat('dd.MM.yyyy');

  DateFormat get dayMonthYearShort => DateFormat('dd.MM');

  String toFormattedString() {
    return dayMonthYear.format(this);
  }

  String toShortFormat() => dayMonthYearShort.format(this);

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get beginingOfCurrentMonth => DateTime(year, month);
  DateTime get endOfCurrentMonth =>
      DateTime(year, month + 1).subtract(const Duration(days: 1));

  DateTime getMonthsAgo(int months) {
    return DateTime(year, month - months);
  }
}
