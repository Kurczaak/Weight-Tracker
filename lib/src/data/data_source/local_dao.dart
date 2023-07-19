import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';

abstract class LocalDao {
  Future<void> init();
  Future<List<WeightRecordEntity>> getAllWeights();
  Future<List<WeightRecordEntity>> getWeightsBetweenDates({
    int? pageNumber,
    int? pageSize,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<WeightRecordEntity> addWeight(WeightRecordEntity weight);
  Future<void> updateWeight(WeightRecordEntity weight);
  Future<void> deleteWeight(WeightRecordEntity weight);
}
