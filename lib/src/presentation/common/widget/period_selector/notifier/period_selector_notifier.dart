import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/model/selected_period.dart';

final periodSelectorNotifierProvider =
    StateNotifierProvider<PeriodSelectorNotifier, SelectedPeriod>(
  (ref) => PeriodSelectorNotifier(),
);

class PeriodSelectorNotifier extends StateNotifier<SelectedPeriod> {
  PeriodSelectorNotifier() : super(SelectedPeriod.month);

  void selectPeriod(SelectedPeriod period) => state = period;
}
