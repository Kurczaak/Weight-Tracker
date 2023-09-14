import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';

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
  Future<void> deletAllWeights();
  Stream<WeightRecord?> watchFirstWeightRecord();
  Stream<WeightRecord?> watchLastWeightRecord();
  Stream<List<WeightRecord>> watchWeights({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  });

  Stream<List<MeanWeight>> watchMontlyMeanWeights();
  Stream<List<MeanWeight>> watchWeeklyMeanWeights();
}
