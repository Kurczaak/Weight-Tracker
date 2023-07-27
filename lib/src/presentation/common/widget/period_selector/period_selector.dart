import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/model/selected_period.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';

class PeriodSelector extends HookWidget {
  const PeriodSelector({
    required this.onSelected,
    this.initiallySelectedPeriod,
    this.tooltip,
    super.key,
  });

  final SelectedPeriod? initiallySelectedPeriod;
  final String? tooltip;
  final void Function(SelectedPeriod selectedPeriod) onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = useState(initiallySelectedPeriod);
    final isOpened = useState(false);

    void handleOnSelected(SelectedPeriod value) {
      selectedPeriod.value = value;
      onSelected(value);
      isOpened.value = false;
    }

    return PopupMenuButton<SelectedPeriod>(
      elevation: 0,
      splashRadius: 0,
      position: PopupMenuPosition.under,
      offset: const Offset(AppDimens.padding2, AppDimens.padding4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.baseRadius),
      ),
      tooltip: tooltip,
      itemBuilder: (context) => SelectedPeriod.values
          .map(
            (e) => PopupMenuItem<SelectedPeriod>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
      onSelected: handleOnSelected,
      onOpened: () => isOpened.value = true,
      onCanceled: () => isOpened.value = false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLarge,
          vertical: AppDimens.paddingMedium,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedPeriod.value?.name ?? 'Open Menu'),
            AppSpacers.w12,
            Icon(isOpened.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }
}
