import 'package:simple_weight_tracker/src/data/repository/config_repository.dart';
import 'package:simple_weight_tracker/src/domain/model/user_config.dart';

class GetGoalWeightUseCase {
  GetGoalWeightUseCase(this._configRepository);
  final ConfigRepository _configRepository;

  Future<double?> call() async {
    final userConfig =
        await _configRepository.getUserConfig() ?? const UserConfig();
    return userConfig.goalWeight;
  }
}
