import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/mappers/user_config_mappers.dart';
import 'package:simple_weight_tracker/src/data/repository/config_repository.dart';
import 'package:simple_weight_tracker/src/domain/model/user_config.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl(this._localDao);

  final LocalDao _localDao;

  @override
  Future<UserConfig?> getUserConfig() =>
      _localDao.getUserConfig().then((value) => value?.toModel());

  @override
  Future<void> saveUserConfig(UserConfig userConfig) =>
      _localDao.saveUserConfig(userConfig.toEntity());
}
