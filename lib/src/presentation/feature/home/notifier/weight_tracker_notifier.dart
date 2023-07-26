import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/provider/use_case_provider.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker_state.dart';

final weightTrackerNotifierProvider =
    StateNotifierProvider<WeightTrackerNotifier, WeightTrackerState>((ref) {
  final addWeightRecordUseCase = ref.watch(saveWeightRecordUseCaseProvider);
  final watchWeightRecordsUseCase =
      ref.watch(watchWeightRecordsUseCaseProvider);
  final deleteWeightRecordUseCase =
      ref.watch(deleteWeightRecordUseCaseProvider);
  final watchInitialWeightUseCase =
      ref.watch(watchInitialWeightUseCaseProvider);
  // Add other use case providers if they exist.
  return WeightTrackerNotifier(
    saveWeightRecordUseCase: addWeightRecordUseCase,
    watchWeightRecordsUseCase: watchWeightRecordsUseCase,
    deleteWeightRecordUseCase: deleteWeightRecordUseCase,
    watchInitialWeightUseCase: watchInitialWeightUseCase,
  );
});

class WeightTrackerNotifier extends StateNotifier<WeightTrackerState> {
  WeightTrackerNotifier({
    required this.saveWeightRecordUseCase,
    required this.watchWeightRecordsUseCase,
    required this.deleteWeightRecordUseCase,
    required this.watchInitialWeightUseCase,
  }) : super(const WeightTrackerState()) {
    _watchWeights();
  }

  static const _pageSize = 10;

  final SaveWeightRecordUseCase saveWeightRecordUseCase;
  final WatchWeightRecordsUseCase watchWeightRecordsUseCase;
  final DeleteWeightRecordUseCase deleteWeightRecordUseCase;
  final WatchInitialWeightUseCase watchInitialWeightUseCase;

  Future<void> addRecord(WeightRecord record) =>
      saveWeightRecordUseCase(record.copyWith(id: null));

  Future<void> updateRecord(WeightRecord record) =>
      saveWeightRecordUseCase(record.copyWith());

  void removeRecord(WeightRecord record) =>
      deleteWeightRecordUseCase.call(record);

  Future<void> _watchWeights() async {
    final latestRecords = await watchWeightRecordsUseCase(
      const WeightRecordDataPaginator(
        dataPaginator: DataPaginator(pageNumber: 0, pageSize: _pageSize),
      ),
    );

    final initiaRecord = await watchInitialWeightUseCase();

    initiaRecord.fold(
      (l) => state = state.copyWith(
        isError: true,
      ),
      (r) => r.listen((event) {
        state = state.copyWith(
          initialWeight: event,
        );
      }),
    );

    latestRecords.fold(
      (l) => state = state.copyWith(
        isError: true,
      ),
      (r) => r.listen((event) {
        state = state.copyWith(
          records: event,
          latestWeight: event.first,
        );
      }),
    );
  }
}
