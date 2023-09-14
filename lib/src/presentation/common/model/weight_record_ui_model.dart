import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';

part 'weight_record_ui_model.freezed.dart';

@freezed
class WeightRecordUIModel with _$WeightRecordUIModel {
  const factory WeightRecordUIModel({
    required double weight,
    required DateTime toDate,
    required int? id,
    WeightRecordUIModelType? type,
    DateTime? fromDate,
  }) = _WeightRecordUIModel;
}

enum WeightRecordUIModelType {
  daily,
  weekly,
  monthly,
}

extension WeighRecordUIModelMappers on WeightRecordUIModel {
  WeightRecordUIModel fromWeightRecord(WeightRecord weightRecord) =>
      WeightRecordUIModel(
        weight: weightRecord.weight,
        toDate: weightRecord.date,
        id: weightRecord.id,
        type: WeightRecordUIModelType.daily,
      );

  WeightRecordUIModel fromMeanWeight(MeanWeight meanWeight) =>
      WeightRecordUIModel(
        weight: meanWeight.meanWeight ?? 0,
        toDate: meanWeight.period.toDate,
        fromDate: meanWeight.period.fromDate,
        id: meanWeight.id,
        type: WeightRecordUIModelType.daily,
      );
}
