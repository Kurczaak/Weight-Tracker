import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/providers/local_dao_provider.dart';
import 'package:simple_weight_tracker/src/data/repository/config_repository.dart';
import 'package:simple_weight_tracker/src/data/repository/config_repository_impl.dart';

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  final localDao = ref.watch(localDaoProvider);
  return ConfigRepositoryImpl(localDao);
});
