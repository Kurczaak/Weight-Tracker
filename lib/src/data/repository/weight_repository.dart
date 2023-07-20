import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

abstract class WeightRepository {
  Future<void> init();
  Future<List<WeightRecord>> getWeights({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  });
  Future<WeightRecord> addWeight(WeightRecord weight);
  Future<void> updateWeight(WeightRecord weight);
  Future<void> deleteWeight(WeightRecord weight);
  Stream<WeightRecord?> watchFirstWeightRecord();
  Stream<WeightRecord?> watchLastWeightRecord();
  Stream<List<WeightRecord>> watchWeightsBetweenDates({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  });
}
