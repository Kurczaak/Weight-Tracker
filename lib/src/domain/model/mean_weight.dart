import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';

part 'mean_weight.freezed.dart';

@freezed
class MeanWeight with _$MeanWeight {
  const factory MeanWeight({
    @Default([]) required List<WeightRecord> records,
  }) = _MeanWeight;
}

extension MeanWeighExtension on MeanWeight {
  int get count => records.length;

  double? get value => records.isEmpty
      ? null
      : records.map((e) => e.weight).reduce((a, b) => a + b) / records.length;

  (DateTime lowerBoud, DateTime upperBound) get dateBound {
    final sortedRecords = records.sorted((a, b) => a.date.compareTo(b.date));
    return (sortedRecords.first.date, sortedRecords.last.date);
  }
}
