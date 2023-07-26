import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/providers/weight_repository_provider.dart';
import 'package:simple_weight_tracker/src/domain/use_case/delete_weight_record_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/save_weight_record_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/watch_weight_records_use_case.dart';

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

// UPDATE

// DELETE

final deleteWeitghtRecordUseCaseProvider = Provider<DeleteWeightRecordUseCase>(
  (ref) {
    final repo = ref.watch(weightRepositoryProvider);
    return DeleteWeightRecordUseCase(repo);
  },
);
