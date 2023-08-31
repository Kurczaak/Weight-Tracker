import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/providers/config_repository_provider.dart';
import 'package:simple_weight_tracker/src/data/providers/weight_repository_provider.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/get_goal_weight.dart';
import 'package:simple_weight_tracker/src/domain/use_case/save_goal_weight_use_case.dart';

// CRUD operations

// CREATE
final saveWeightRecordUseCaseProvider =
    Provider<SaveWeightRecordUseCase>((ref) {
  final repo = ref.watch(weightRepositoryProvider);
  return SaveWeightRecordUseCase(repo);
});

final saveGoalWeightUseCaseProvider = Provider<SaveGoalWeightUseCase>((ref) {
  final repo = ref.watch(configRepositoryProvider);
  return SaveGoalWeightUseCase(repo);
});

// READ
final watchWeightRecordsUseCaseProvider =
    Provider<WatchWeightRecordsUseCase>((ref) {
  final repo = ref.watch(weightRepositoryProvider);
  return WatchWeightRecordsUseCase(repo);
});
final watchInitialWeightUseCaseProvider =
    Provider<WatchInitialWeightUseCase>((ref) {
  final repo = ref.watch(weightRepositoryProvider);
  return WatchInitialWeightUseCase(repo);
});

final getGoalWeightUseCaseProvider = Provider<GetGoalWeightUseCase>((ref) {
  final repo = ref.watch(configRepositoryProvider);
  return GetGoalWeightUseCase(repo);
});

// UPDATE

// DELETE

final deleteWeightRecordUseCaseProvider = Provider<DeleteWeightRecordUseCase>(
  (ref) {
    final repo = ref.watch(weightRepositoryProvider);
    return DeleteWeightRecordUseCase(repo);
  },
);
