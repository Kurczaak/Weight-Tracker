import 'package:simple_weight_tracker/src/data/entity/mean_weight_entity.dart';
import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';

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

extension WeightRecordEntityListMappers on List<WeightRecordEntity> {
  List<WeightRecord> toModelList() => map((e) => e.toModel()).toList();
}
