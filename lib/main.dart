import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/home_page.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker_notifier.dart';

// TODO refactor to use a repository
final weightProvider = StateProvider((ref) => <WeightRecord>[]);

// TODO refactor
final weightTrackerNotifierProvider =
    StateNotifierProvider<WeightTrackerNotifier, List<WeightRecord>>((ref) {
  final weightRepository = ref.watch(weightProvider);
  return WeightTrackerNotifier.fromState(weightRepository);
});

void main() => runApp(
      ProviderScope(
        child: DevicePreview(
          enabled: !kReleaseMode && kIsWeb,
          builder: (context) => const MyApp(), // Wrap your app
        ),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
