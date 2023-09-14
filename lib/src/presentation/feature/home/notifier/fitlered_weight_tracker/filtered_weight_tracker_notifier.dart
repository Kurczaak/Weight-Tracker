import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/model/selected_period.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/notifier/period_selector_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker/weight_tracker_notifier.dart';

final filteredWeightTrackerProvider = Provider<List<WeightRecord>>((ref) {
  final period = ref.watch(periodSelectorNotifierProvider);
  final weightRecordsProvider =
      weightTrackerNotifierProvider(period.dateBoundaries);

  final recordsProvider = ref.watch(weightRecordsProvider);

  return recordsProvider.records;
});
