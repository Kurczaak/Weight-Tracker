import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao_impl.dart';
import 'package:simple_weight_tracker/src/data/providers/local_dao_provider.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localDao = await LocalDaoImpl.withIsarDB();
  runApp(
    ProviderScope(
      overrides: [
        localDaoProvider.overrideWithValue(localDao),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode && kIsWeb,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

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
