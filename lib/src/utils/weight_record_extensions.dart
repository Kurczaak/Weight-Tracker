import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

extension WeightRecordExtension on List<WeightRecord> {
  List<WeightRecord> get orderedByDate =>
      [...this]..sort((a, b) => a.date.compareTo(b.date));
}
