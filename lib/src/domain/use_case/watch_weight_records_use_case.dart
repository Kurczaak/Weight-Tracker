import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';

class WatchWeightRecordsUseCase
    extends UseCase<Stream<List<WeightRecord>>, WeightRecordDataPaginator> {
  WatchWeightRecordsUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<Stream<List<WeightRecord>>> execute(
    WeightRecordDataPaginator param,
  ) async =>
      _repository.watchWeights(
        fromDate: param.dateBoundaries?.fromDate,
        toDate: param.dateBoundaries?.toDate,
        dataPaginator: param.dataPaginator,
      );
}
