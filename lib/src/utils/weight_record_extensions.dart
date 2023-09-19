import 'package:simple_weight_tracker/src/domain/model/export_model.dart';
import 'package:simple_weight_tracker/src/presentation/common/model/weight_record_ui_model.dart';

extension WeightRecordExtension on List<WeightRecord> {
  List<WeightRecord> get orderedByDate =>
      [...this]..sort((a, b) => a.date.compareTo(b.date));

  double? get meanWeight => isEmpty
      ? null
      : fold<double>(
            0,
            (previousValue, element) => previousValue + element.weight,
          ) /
          length;
}

extension WeightRecordUIModelExtension on List<WeightRecordUIModel> {
  List<WeightRecordUIModel> get orderedByDate =>
      [...this]..sort((a, b) => b.toDate.compareTo(a.toDate));
}
