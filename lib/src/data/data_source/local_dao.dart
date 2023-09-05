import 'package:simple_weight_tracker/src/data/entity/export_entity.dart';

abstract class LocalDao {
  Future<void> init();
  Future<WeightRecordEntity?> getFirstWeightRecord();
  Future<WeightRecordEntity?> getLastWeightRecord();
  Future<List<WeightRecordEntity>> getWeightsBetweenDates({
    int? pageNumber,
    int? pageSize,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Stream<List<WeightRecordEntity>> watchWeights({
    int? pageNumber,
    int? pageSize,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Stream<WeightRecordEntity?> watchFirstWeightRecord();
  Stream<WeightRecordEntity?> watchLastWeightRecord();
  Future<WeightRecordEntity> addWeight(WeightRecordEntity weight);
  Future<void> updateWeight(WeightRecordEntity weight);
  Future<void> deleteWeight(WeightRecordEntity weight);
  Future<void> deleteAllWeights();
  Future<UserConfigEntity?> getUserConfig();
  Future<void> saveUserConfig(UserConfigEntity userConfig);
}
