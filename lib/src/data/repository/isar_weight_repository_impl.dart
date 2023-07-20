import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/mappers/weight_record_mappers.dart';
import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class IsarWeightRepositoryImpl implements WeightRepository {
  IsarWeightRepositoryImpl(this._localDao);

  final LocalDao _localDao;

  @override
  Future<WeightRecord> addWeight(WeightRecord weight) =>
      _localDao.addWeight(weight.toEntity()).then((value) => value.toModel());

  @override
  Future<void> deleteWeight(WeightRecord weight) => _localDao.deleteWeight(
        weight.toEntity(),
      );

  @override
  Future<List<WeightRecord>> getWeights({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  }) =>
      _localDao
          .getWeightsBetweenDates(
            fromDate: fromDate,
            toDate: toDate,
            pageNumber: dataPaginator?.pageNumber,
            pageSize: dataPaginator?.pageSize,
          )
          .then(
            (value) => value.toModelList(),
          );

  @override
  Future<void> updateWeight(WeightRecord weight) => _localDao.updateWeight(
        weight.toEntity(),
      );

  @override
  Future<void> init() => _localDao.init();

  @override
  Stream<WeightRecord?> watchFirstWeightRecord() =>
      _localDao.watchFirstWeightRecord().map((event) => event?.toModel());

  @override
  Stream<WeightRecord?> watchLastWeightRecord() =>
      _localDao.watchLastWeightRecord().map((event) => event?.toModel());

  @override
  Stream<List<WeightRecord>> watchWeightsBetweenDates({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  }) =>
      _localDao
          .watchWeightsBetweenDates(
            fromDate: fromDate,
            toDate: toDate,
            pageNumber: dataPaginator?.pageNumber,
            pageSize: dataPaginator?.pageSize,
          )
          .map(
            (event) => event.toModelList(),
          );
}
