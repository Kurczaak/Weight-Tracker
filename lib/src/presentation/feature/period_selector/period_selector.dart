import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_weight_tracker/src/presentation/feature/period_selector/model/selected_period.dart';

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
      position: PopupMenuPosition.under,
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
      child: Row(
        children: [
          Text(selectedPeriod.value?.name ?? 'Open Menu'),
          Icon(isOpened.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)
        ],
      ),
    );
  }
}
