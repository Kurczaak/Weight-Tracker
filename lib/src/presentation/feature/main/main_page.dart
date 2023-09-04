import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/bottom_bar/base_bottom_navigation_bar.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/home_page.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageIndex = useState(0);
    final controller = usePageController(initialPage: pageIndex.value);

    void onPageChanged(int index) => pageIndex.value = index;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: PageView(
          onPageChanged: onPageChanged,
          controller: controller,
          children: [
            const HomePage(),
            Container(
              child: const Placeholder(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BaseBottomNavigationBar(
        pageIndex: pageIndex,
        onTap: (index) => _onBottomBarTapped(index, controller),
      ),
    );
  }

  void _onBottomBarTapped(int index, PageController controller) =>
      controller.animateToPage(
        index,
        duration: AppConsts.bottomBarNavigationDuration,
        curve: Curves.easeInOut,
      );
}
