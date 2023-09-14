import 'package:simple_weight_tracker/src/domain/model/export_model.dart';

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
