import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/l10n/l10n.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao_impl.dart';
import 'package:simple_weight_tracker/src/data/providers/local_dao_provider.dart';
import 'package:simple_weight_tracker/src/presentation/feature/main/main_page.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localDao = await LocalDaoImpl.withIsarDB();
  runApp(
    ProviderScope(
      overrides: [
        localDaoProvider.overrideWithValue(localDao),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.darkTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainPage(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
