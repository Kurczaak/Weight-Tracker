import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/use_case/delete_weight_record_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/provider/use_case_provider.dart';
import 'package:simple_weight_tracker/src/domain/use_case/save_weight_record_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/watch_weight_records_use_case.dart';

final weightTrackerNotifierProvider =
    StateNotifierProvider<WeightTrackerNotifier, List<WeightRecord>>((ref) {
  final addWeightRecord = ref.watch(saveWeightRecordUseCaseProvider);
  final watchWeightRecords = ref.watch(watchWeightRecordsUseCaseProvider);
  final deleteWeightRecord = ref.watch(deleteWeitghtRecordUseCaseProvider);
  // Add other use case providers if they exist.
  return WeightTrackerNotifier(
    addWeightRecord,
    watchWeightRecords,
    deleteWeightRecord,
  );
});

class WeightTrackerNotifier extends StateNotifier<List<WeightRecord>> {
  WeightTrackerNotifier(
    this._saveWeightRecordUseCase,
    this._watchWeightRecordsUseCase,
    this._deleteWeightRecordUseCase,
  ) : super([]) {
    _watchWeights();
  }

  final SaveWeightRecordUseCase _saveWeightRecordUseCase;
  final WatchWeightRecordsUseCase _watchWeightRecordsUseCase;
  final DeleteWeightRecordUseCase _deleteWeightRecordUseCase;

  Future<void> addRecord(WeightRecord record) =>
      _saveWeightRecordUseCase(record.copyWith(id: null));

  void removeRecord(WeightRecord record) =>
      _deleteWeightRecordUseCase.call(record);

  Future<void> _watchWeights() async {
    final records = await _watchWeightRecordsUseCase(
      const WeightRecordDataPaginator(),
    );
    records.fold(
      (l) => state = [],
      (r) => r.listen((event) {
        state = event;
      }),
    );
  }
}
