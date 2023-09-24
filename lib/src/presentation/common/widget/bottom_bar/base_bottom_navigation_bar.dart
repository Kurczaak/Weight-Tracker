import 'package:flutter/material.dart';
import 'package:simple_weight_tracker/l10n/l10n.dart';

class BaseBottomNavigationBar extends StatelessWidget {
  const BaseBottomNavigationBar({
    required this.pageIndex,
    required this.onTap,
    super.key,
  });

  final ValueNotifier<int> pageIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      currentIndex: pageIndex.value,
      items: [
        BottomNavigationBarItem(
          label: context.str.general__home,
          icon: const Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: context.str.general__list,
          icon: const Icon(Icons.list),
        ),
      ],
    );
  }
}
