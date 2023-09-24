import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/date_boundaries.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/provider/use_case_provider.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker/weight_tracker_state.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';
import 'package:simple_weight_tracker/src/utils/weight_record_extensions.dart';

final weightTrackerNotifierProvider = StateNotifierProvider.family<
    WeightTrackerNotifier,
    WeightTrackerState,
    DateBoundaries?>((ref, dateBoundaries) {
  final addWeightRecordUseCase = ref.watch(saveWeightRecordUseCaseProvider);
  final watchWeightRecordsUseCase =
      ref.watch(watchWeightRecordsUseCaseProvider);
  final deleteWeightRecordUseCase =
      ref.watch(deleteWeightRecordUseCaseProvider);
  final watchInitialWeightUseCase =
      ref.watch(watchInitialWeightUseCaseProvider);
  final saveGoalWeightUseCase = ref.watch(saveGoalWeightUseCaseProvider);
  final getGoalWeightUseCase = ref.watch(getGoalWeightUseCaseProvider);

  return WeightTrackerNotifier(
    saveWeightRecordUseCase: addWeightRecordUseCase,
    watchWeightRecordsUseCase: watchWeightRecordsUseCase,
    deleteWeightRecordUseCase: deleteWeightRecordUseCase,
    watchInitialWeightUseCase: watchInitialWeightUseCase,
    saveGoalWeightUseCase: saveGoalWeightUseCase,
    getGoalWeightUseCase: getGoalWeightUseCase,
    dateBoundaries: dateBoundaries,
  );
});

class WeightTrackerNotifier extends StateNotifier<WeightTrackerState> {
  WeightTrackerNotifier({
    required SaveWeightRecordUseCase saveWeightRecordUseCase,
    required WatchWeightRecordsUseCase watchWeightRecordsUseCase,
    required DeleteWeightRecordUseCase deleteWeightRecordUseCase,
    required WatchInitialWeightUseCase watchInitialWeightUseCase,
    required SaveGoalWeightUseCase saveGoalWeightUseCase,
    required GetGoalWeightUseCase getGoalWeightUseCase,
    required DateBoundaries? dateBoundaries,
  })  : _watchInitialWeightUseCase = watchInitialWeightUseCase,
        _deleteWeightRecordUseCase = deleteWeightRecordUseCase,
        _watchWeightRecordsUseCase = watchWeightRecordsUseCase,
        _saveWeightRecordUseCase = saveWeightRecordUseCase,
        _saveGoalWeightUseCase = saveGoalWeightUseCase,
        _getGoalWeightUseCase = getGoalWeightUseCase,
        _dateBoundaries = dateBoundaries,
        super(const WeightTrackerState()) {
    init(dateBoundaries: _dateBoundaries);
  }

  final DateBoundaries? _dateBoundaries;
  final SaveWeightRecordUseCase _saveWeightRecordUseCase;
  final WatchWeightRecordsUseCase _watchWeightRecordsUseCase;
  final DeleteWeightRecordUseCase _deleteWeightRecordUseCase;
  final WatchInitialWeightUseCase _watchInitialWeightUseCase;
  final SaveGoalWeightUseCase _saveGoalWeightUseCase;
  final GetGoalWeightUseCase _getGoalWeightUseCase;

  StreamSubscription<List<WeightRecord?>>? _weightRecordsSubscription;

  Future<void> addRecord(WeightRecord record) => _saveWeightRecordUseCase
      .call(record.copyWith(date: record.date.startOfDay, id: null));

  void removeRecord(WeightRecord record) =>
      _deleteWeightRecordUseCase.call(record);

  Future<void> watchWeights({DateBoundaries? dateBoundaries}) async {
    final latestRecords = await _watchWeightRecordsUseCase(
      WeightRecordDataPaginator(
        dateBoundaries: dateBoundaries,
      ),
    );

    latestRecords.fold(
        (l) => state = state.copyWith(
              isError: true,
            ), (r) {
      _weightRecordsSubscription?.cancel();
      _weightRecordsSubscription = r.listen((event) {
        state = state.copyWith(
          records: event.orderedByDate,
          latestWeight: event.isNotEmpty ? event.first : null,
        );
      });
    });
  }

  Future<void> saveGoalWeight(double weight) async {
    state = state.copyWith(goalWeight: weight);
    await _saveGoalWeightUseCase.call(weight);
  }

  Future<void> init({DateBoundaries? dateBoundaries}) async {
    final goalWeight = await _getGoalWeightUseCase();

    final initiaRecord = await _watchInitialWeightUseCase();
    initiaRecord.fold(
      (l) => state = state.copyWith(
        isError: true,
      ),
      (r) => r.listen((event) {
        state = state.copyWith(
          initialWeight: event,
          goalWeight: goalWeight,
        );
      }),
    );
    await watchWeights(dateBoundaries: dateBoundaries);
  }

  @override
  void dispose() {
    _weightRecordsSubscription?.cancel();
    super.dispose();
  }
}
