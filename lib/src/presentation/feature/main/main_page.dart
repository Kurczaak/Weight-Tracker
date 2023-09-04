import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/home_page.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageIndex = useState(0);
    final controller = usePageController(initialPage: pageIndex.value);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: PageView(
          onPageChanged: (value) {
            pageIndex.value = value;
          },
          controller: controller,
          children: [
            const HomePage(),
            Container(
              child: const Placeholder(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          pageIndex.value = value;
          controller.animateToPage(
            value,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        currentIndex: pageIndex.value,
        items: const [
          BottomNavigationBarItem(
            label: 'Home', // TODO (kura) translations
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'List', // TODO (kura) translations
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}
