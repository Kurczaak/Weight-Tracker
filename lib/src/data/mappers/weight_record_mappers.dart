import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

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
}

extension WeightRecordEntityListMappers on List<WeightRecordEntity> {
  List<WeightRecord> toModelList() => map((e) => e.toModel()).toList();
}
