import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

part 'weight_tracker_state.freezed.dart';

@freezed
class WeightTrackerState with _$WeightTrackerState {
  const factory WeightTrackerState({
    @Default([]) List<WeightRecord> records,
    WeightRecord? initialWeight,
    WeightRecord? latestWeight,
    @Default(false) bool isError,
  }) = _WeightTrackerState;
}
