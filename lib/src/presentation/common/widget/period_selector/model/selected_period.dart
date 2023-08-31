import 'package:simple_weight_tracker/src/domain/model/date_boundaries.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';

enum SelectedPeriod {
  month(1),
  quarterly(AppConsts.monthsInYear ~/ 4),
  halfYear(AppConsts.monthsInYear ~/ 2),
  year(AppConsts.monthsInYear),
  begining(null);

  const SelectedPeriod(this.monthsCount);

  final int? monthsCount;
}

extension SelectedPeriodExtension on SelectedPeriod {
  DateTime get fromDate => monthsCount == null
      ? AppConsts.oldestPossibleDate
      : DateTime.now().getMonthsAgo(monthsCount!);

  DateTime get toDate => DateTime.now().endOfCurrentMonth;

  DateBoundaries get dateBoundaries =>
      DateBoundaries(fromDate: fromDate, toDate: toDate);
}
