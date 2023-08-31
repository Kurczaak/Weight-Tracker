import 'package:simple_weight_tracker/src/data/repository/config_repository.dart';
import 'package:simple_weight_tracker/src/domain/model/user_config.dart';

class SaveGoalWeightUseCase {
  SaveGoalWeightUseCase(this._configRepository);
  final ConfigRepository _configRepository;

  Future<void> call(double goalWeight) async {
    final userConfig =
        await _configRepository.getUserConfig() ?? const UserConfig();
    await _configRepository
        .saveUserConfig(userConfig.copyWith(goalWeight: goalWeight));
  }
}
