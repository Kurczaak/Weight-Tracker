import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

abstract class WeightRepository {
  Future<void> init();
  Future<List<WeightRecord>> getWeights();
  Future<void> addWeight(WeightRecord weight);
  Future<void> updateWeight(WeightRecord weight);
  Future<void> deleteWeight(WeightRecord weight);
}
