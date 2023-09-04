import 'package:simple_weight_tracker/src/domain/model/user_config.dart';

abstract class ConfigRepository {
  Future<void> saveUserConfig(UserConfig userConfig);
  Future<UserConfig?> getUserConfig();
}
