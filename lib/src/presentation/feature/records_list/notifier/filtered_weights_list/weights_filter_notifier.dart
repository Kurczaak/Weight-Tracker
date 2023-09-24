import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/presentation/common/model/weight_record_ui_model.dart';

final weightsFilterNotifierProvider =
    StateNotifierProvider<WeightsFilterProvider, WeightRecordUIModelType>(
  (ref) => WeightsFilterProvider(),
);

class WeightsFilterProvider extends StateNotifier<WeightRecordUIModelType> {
  WeightsFilterProvider() : super(WeightRecordUIModelType.weekly);

  void selectFilter(WeightRecordUIModelType type) => state = type;
}
