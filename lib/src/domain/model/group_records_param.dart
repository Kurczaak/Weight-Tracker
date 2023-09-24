import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';

part 'group_records_param.freezed.dart';

@freezed
class GroupRecordsParam with _$GroupRecordsParam {
  const factory GroupRecordsParam({
    required DateTime startDate,
    required int daysCount,
    required List<WeightRecord> allRecords,
  }) = _GroupRecordsParam;
}
