import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateFormat get dayMonthYear => DateFormat('dd.MM.yyyy');

  String toFormattedString() {
    return dayMonthYear.format(this);
  }

  DateTime get startOfDay => DateTime(year, month, day);
}
