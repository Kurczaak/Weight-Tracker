import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/provider/use_case_provider.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker_state.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';

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
  }) : super(const WeightTrackerState());

  final SaveWeightRecordUseCase saveWeightRecordUseCase;
  final WatchWeightRecordsUseCase watchWeightRecordsUseCase;
  final DeleteWeightRecordUseCase deleteWeightRecordUseCase;
  final WatchInitialWeightUseCase watchInitialWeightUseCase;

  Future<void> addRecord(WeightRecord record) => saveWeightRecordUseCase
      .call(record.copyWith(date: record.date.startOfDay, id: null));

  void removeRecord(WeightRecord record) =>
      deleteWeightRecordUseCase.call(record);

  Future<void> initWatchWeights(int recordsCount) async {
    final latestRecords = await watchWeightRecordsUseCase(
      WeightRecordDataPaginator(
        dataPaginator: DataPaginator(pageNumber: 0, pageSize: recordsCount),
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
          latestWeight: event.isNotEmpty ? event.first : null,
        );
      }),
    );
  }
}
