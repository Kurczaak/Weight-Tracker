class AppConsts {
  AppConsts._();
  static const int homePageRecordsCount = 100;

  // Date-time
  static const maxDaysInMonth = 31;
  static const weeksInMonth = 4;
  static const monthsInYear = 12;
  static const daysInWeek = 7;
  static DateTime oldestPossibleDate = DateTime(2010);

  // Screen Sizes
  static const double mobileScreenWidth = 600;
  static const double tabletScreenWidth = 950;

  // Weight chars
  static const double mobileXAxisPointsCount = 3;
  static const double tabletXAxisPointsCount = 7;
  static const double desktopXAxisPointsCount = 12;

  // String related
  static const String emptyPlaceholder = '-';

  // Durations
  static const Duration bottomBarNavigationDuration =
      Duration(milliseconds: 300);

  // Records List
  static const int recordsListPageSize = 40;
  static const Duration debouncerDuration = Duration(milliseconds: 200);
}
