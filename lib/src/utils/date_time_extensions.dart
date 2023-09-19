import 'package:intl/intl.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';

extension DateTimeExtensions on DateTime {
  DateFormat get dayMonthYear => DateFormat('dd.MM.yyyy');

  DateFormat get dayMonthYearShort => DateFormat('dd.MM');

  DateFormat get monthFormat => DateFormat('MMMM yyyy');

  String toFormattedString() {
    return dayMonthYear.format(this);
  }

  String get monthYearFormatted => monthFormat.format(this);

  String toShortFormat() => dayMonthYearShort.format(this);

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get beginingOfCurrentMonth => DateTime(year, month);
  DateTime get endOfCurrentMonth =>
      DateTime(year, month + 1).subtract(const Duration(days: 1));

  DateTime getMonthsAgo(int months) {
    return DateTime(year, month - months);
  }

  DateTime get endOfWeek {
    // Because in Dart, Monday is 1 and Sunday is 7
    final daysToSunday = AppConsts.daysInWeek - weekday;
    return add(Duration(days: daysToSunday));
  }

  // Calculations based on (Algorithms section)
// https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int get weekNumber {
    var weekOfYear = _getWeekOfYear(this);
    if (weekOfYear < 1) {
      weekOfYear = _numOfWeeks(year - 1);
    } else if (weekOfYear > _numOfWeeks(year)) {
      weekOfYear = 1;
    }
    return weekOfYear;
  }

  // Calculations based on (Algorithm section)
  // https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    // The number of weeks in a given year is equal to the corresponding week
    // number of 28 December, because it is the only date that is always in the
    // last week of the year since it is a week before 4 January which is
    // always in the first week of the following year.
    final dec28 = DateTime(year, 12, 28);
    return _getWeekOfYear(dec28);
  }

  int _getWeekOfYear(DateTime date) {
    final dayOfYear = _getDayOfYear(date);
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  int _getDayOfYear(DateTime date) => int.parse(DateFormat('D').format(date));

  bool isAtSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
