import 'package:isar/isar.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao_consts.dart';

part 'weight_record_entity.g.dart';

@collection
class WeightRecordEntity {
  WeightRecordEntity({
    required this.weight,
    required this.date,
    required this.id,
  });

  Id? id;

  final double weight;
  @Index(
    unique: true,
    replace: true,
    name: LocalDaoConsts.dateIndexName,
  )
  final DateTime date;
}
