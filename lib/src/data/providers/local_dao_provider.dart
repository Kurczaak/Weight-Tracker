import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';

final localDaoProvider = Provider<LocalDao>((ref) {
  // can't return a LocalDao becuase the initializer is async
  // so we throw an error instead and overrider the provider in the main.dart
  throw UnimplementedError();
});
