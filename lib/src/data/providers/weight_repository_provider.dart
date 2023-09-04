import 'package:riverpod/riverpod.dart';
import 'package:simple_weight_tracker/src/data/providers/local_dao_provider.dart';
import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/data/repository/weight_repository_impl.dart';

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  final localDao = ref.watch(localDaoProvider);
  return WeightRepositoryImpl(localDao);
});
