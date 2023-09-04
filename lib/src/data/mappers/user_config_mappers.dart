import 'package:simple_weight_tracker/src/data/entity/user_config_entity.dart';
import 'package:simple_weight_tracker/src/domain/model/user_config.dart';

extension UserConfigMappers on UserConfig {
  UserConfigEntity toEntity() => UserConfigEntity(
        goalWeight: goalWeight,
        selectedPeriodIndex: selectedPeriodIndex,
      );
}

extension UserConfigEntityMappers on UserConfigEntity {
  UserConfig toModel() => UserConfig(
        goalWeight: goalWeight,
        selectedPeriodIndex: selectedPeriodIndex ?? 0,
      );
}
