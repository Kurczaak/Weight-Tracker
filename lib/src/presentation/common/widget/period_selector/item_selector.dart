import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';

class SelectorItem<T> {
  const SelectorItem({
    required this.value,
    required this.name,
  });

  final T value;
  final String name;
}

class ItemSelector<T> extends HookWidget {
  const ItemSelector({
    required this.onSelected,
    required this.items,
    this.initialItem,
    this.tooltip,
    super.key,
  });

  final SelectorItem<T>? initialItem;
  final List<SelectorItem<T>> items;
  final String? tooltip;
  final void Function(SelectorItem<T> selectedPeriod) onSelected;

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'Items cannot be empty');

    final selectedPeriod = useState(initialItem ?? items.first);
    final isOpened = useState(false);

    void handleOnSelected(SelectorItem<T> value) {
      selectedPeriod.value = value;
      onSelected(value);
      isOpened.value = false;
    }

    return PopupMenuButton<SelectorItem<T>>(
      elevation: 0,
      splashRadius: 0,
      position: PopupMenuPosition.under,
      offset: const Offset(AppDimens.padding2, AppDimens.padding4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.baseRadius),
      ),
      tooltip: tooltip,
      itemBuilder: _buildItems,
      onSelected: handleOnSelected,
      onOpened: () => isOpened.value = true,
      onCanceled: () => isOpened.value = false,
      child: _PeriodSelectorBody<T>(
        selectedItem: selectedPeriod,
        isOpened: isOpened,
      ),
    );
  }

  List<PopupMenuEntry<SelectorItem<T>>> _buildItems(BuildContext context) =>
      items
          .map(
            (e) => PopupMenuItem<SelectorItem<T>>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList();
}

class _PeriodSelectorBody<T> extends StatelessWidget {
  const _PeriodSelectorBody({
    required this.selectedItem,
    required this.isOpened,
  });

  final ValueNotifier<SelectorItem<T>> selectedItem;
  final ValueNotifier<bool> isOpened;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedItem.value.name,
          ),
          AppSpacers.w12,
          Icon(isOpened.value ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
