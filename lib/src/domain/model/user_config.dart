import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_config.freezed.dart';

@freezed
class UserConfig with _$UserConfig {
  const factory UserConfig({
    @Default(null) double? goalWeight,
    @Default(0) int selectedPeriodIndex,
  }) = _UserConfig;
}
