import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/presentation/common/model/weight_record_ui_model.dart';

part 'weights_scroll_list_state.freezed.dart';

@freezed
class WeightsScrollListState with _$WeightsScrollListState {
  const factory WeightsScrollListState({
    @Default([]) List<WeightRecordUIModel> records,
    @Default(false) bool isLoading,
    @Default(false) bool hasReachedEndOfRecords,
  }) = _WeightsScrollListState;
}
