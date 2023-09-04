import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_record.freezed.dart';

@freezed
class WeightRecord with _$WeightRecord {
  const factory WeightRecord({
    required double weight,
    required DateTime date,
    int? id,
  }) = _WeightRecord;
}
