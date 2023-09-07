import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';
import 'package:simple_weight_tracker/src/domain/model/mean_weight.dart';

class GroupRecordsUseCase extends UseCase<List<MeanWeight>, GroupRecordsParam> {
  @override
  Future<List<MeanWeight>> execute(GroupRecordsParam param) async {
    final meanRecords = <MeanWeight>[];
    final groupedWeightRecords = <WeightRecord>[];
    var toDate = param.startDate;
    var fromDate = param.startDate.subtract(Duration(days: param.daysCount));
    for (final record in param.allRecords) {
      if (_isRecordWithinDateBoundaries(record, fromDate, toDate)) {
        groupedWeightRecords.add(record);
      } else {
        final updatedBoundaries = _handleRecordOutsideDateBoundaries(
          groupedWeightRecords,
          meanRecords,
          toDate,
          fromDate,
          param,
        );
        fromDate = updatedBoundaries.updatedFromDate;
        toDate = updatedBoundaries.updatedToDate;
      }
    }
    return meanRecords;
  }

  ({DateTime updatedFromDate, DateTime updatedToDate})
      _handleRecordOutsideDateBoundaries(
    List<WeightRecord> groupedWeightRecords,
    List<MeanWeight> meanRecords,
    DateTime toDate,
    DateTime fromDate,
    GroupRecordsParam param,
  ) {
    if (groupedWeightRecords.isNotEmpty) {
      meanRecords.add(MeanWeight(records: [...groupedWeightRecords]));
    }
    groupedWeightRecords.clear();
    return (
      updatedFromDate: fromDate.subtract(const Duration(days: 1)),
      updatedToDate: toDate.subtract(Duration(days: param.daysCount))
    );
  }
}

bool _isRecordWithinDateBoundaries(
  WeightRecord record,
  DateTime fromDate,
  DateTime toDate,
) =>
    record.date.isAfter(fromDate) && record.date.isBefore(toDate);
