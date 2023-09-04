import 'package:isar/isar.dart';

part 'user_config_entity.g.dart';

@collection
class UserConfigEntity {
  UserConfigEntity({
    required this.goalWeight,
    required this.selectedPeriodIndex,
    this.id = 0,
  });

  Id id;

  final double? goalWeight;
  final int? selectedPeriodIndex;
}
