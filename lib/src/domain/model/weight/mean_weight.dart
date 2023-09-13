import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';
import 'package:simple_weight_tracker/src/utils/weight_record_extensions.dart';

part 'mean_weight.freezed.dart';

@freezed
class MeanWeight with _$MeanWeight {
  const factory MeanWeight({
    required List<WeightRecord> weightRecords,
  }) = _MeanWeight;

  const MeanWeight._();

  double? get meanWeight => weightRecords.meanWeight;
  (DateTime fromDate, DateTime toDate) get period {
    final orderedRecords = weightRecords.orderedByDate;
    return (orderedRecords.first.date, orderedRecords.last.date);
  }
}
