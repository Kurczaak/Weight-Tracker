import 'package:simple_weight_tracker/src/data/entity/mean_weight_entity.dart';
import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';

extension WeightRecordMappers on WeightRecord {
  WeightRecordEntity toEntity() => WeightRecordEntity(
        id: id,
        weight: weight,
        date: date,
      );
}

extension WeightRecordEntityMappers on WeightRecordEntity {
  WeightRecord toModel() => WeightRecord(
        weight: weight,
        date: date,
        id: id,
      );

  EmbededWeightRecord toEmbededModel() => EmbededWeightRecord(
        weight: weight,
        dateTime: date,
        id: id,
      );
}

extension EmbededWeightRecordMappers on EmbededWeightRecord {
  WeightRecord toModel() => WeightRecord(
        id: id,
        weight: weight ?? 0,
        date: dateTime ?? DateTime.now()
          ..add(const Duration(days: 365)),
      );
}

extension EmbededWeightRecordListMappers on List<EmbededWeightRecord> {
  List<WeightRecord> toModelList() => map((e) => e.toModel()).toList();
}

extension WeightRecordEntityListMappers on List<WeightRecordEntity> {
  List<WeightRecord> toModelList() => map((e) => e.toModel()).toList();
}

extension WeeklyMeanWeightEntityMappers on WeeklyMeanWeightEntity {
  MeanWeight toModel() => MeanWeight(
        weightRecords: weightRecords.toModelList(),
      );
}

extension WeeklyMeanWeightEntityListMappers on List<WeeklyMeanWeightEntity> {
  List<MeanWeight> toModelList() => map((e) => e.toModel()).toList();
}

extension MonthlyMeanWeightEntityMappers on MonthlyMeanWeightEntity {
  MeanWeight toModel() => MeanWeight(
        weightRecords: weightRecords.toModelList(),
      );
}

extension MonthlyMeanWeightEntityListMappers on List<MonthlyMeanWeightEntity> {
  List<MeanWeight> toModelList() => map((e) => e.toModel()).toList();
}
