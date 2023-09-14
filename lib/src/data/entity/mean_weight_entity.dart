import 'package:isar/isar.dart';

part 'mean_weight_entity.g.dart';

@collection
class WeeklyMeanWeightEntity {
  WeeklyMeanWeightEntity({
    required this.weightRecords,
    required this.id,
  });

  /// Year * 100 + week number
  Id? id;

  List<EmbededWeightRecord> weightRecords;
}

@collection
class MonthlyMeanWeightEntity {
  MonthlyMeanWeightEntity({
    required this.weightRecords,
    required this.id,
  });

  /// Year * 100 + month number
  Id? id;

  List<EmbededWeightRecord> weightRecords;
}

@embedded
class EmbededWeightRecord {
  EmbededWeightRecord({
    this.dateTime,
    this.weight,
    this.id,
  });
  DateTime? dateTime;
  double? weight;
  int? id;
}
