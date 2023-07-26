import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/providers/weight_repository_provider.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';

// CRUD operations

// CREATE
final saveWeightRecordUseCaseProvider =
    Provider<SaveWeightRecordUseCase>((ref) {
  final repo = ref.watch(weightRepositoryProvider);
  return SaveWeightRecordUseCase(repo);
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

// UPDATE

// DELETE

final deleteWeightRecordUseCaseProvider = Provider<DeleteWeightRecordUseCase>(
  (ref) {
    final repo = ref.watch(weightRepositoryProvider);
    return DeleteWeightRecordUseCase(repo);
  },
);
