import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class WeightTrackerNotifier extends StateNotifier<List<WeightRecord>> {
  WeightTrackerNotifier({this.records}) : super([]);
  factory WeightTrackerNotifier.fromState(List<WeightRecord> state) {
    return WeightTrackerNotifier(records: state);
  }

  final List<WeightRecord>? records;

  void addRecord(WeightRecord record) {
    state = [...state, record];
  }

  void removeRecord(WeightRecord record) {
    state = state.where((r) => r != record).toList();
  }
}
