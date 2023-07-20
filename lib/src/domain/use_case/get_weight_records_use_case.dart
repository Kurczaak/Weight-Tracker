import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record_data_paginator.dart';

class GetWeightRecordsUseCase
    extends UseCase<List<WeightRecord>, WeightRecordDataPaginator> {
  GetWeightRecordsUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<List<WeightRecord>> execute(WeightRecordDataPaginator param) =>
      _repository.getWeights(
        fromDate: param.fromDate,
        toDate: param.toDate,
        dataPaginator: param.dataPaginator,
      );
}
