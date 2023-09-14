import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_record_ui_model.freezed.dart';

@freezed
class WeightRecordUIModel with _$WeightRecordUIModel {
  const factory WeightRecordUIModel({
    required double weight,
    required DateTime toDate,
    required int id,
    DateTime? fromDate,
  }) = _WeightRecordUIModel;
}

enum WeightRecordUIModelType {
  daily,
  weekly,
  monthly,
}
