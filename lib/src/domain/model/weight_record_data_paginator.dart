import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/src/domain/model/data_paginator.dart';

part 'weight_record_data_paginator.freezed.dart';

@freezed
class WeightRecordDataPaginator with _$WeightRecordDataPaginator {
  const factory WeightRecordDataPaginator({
    DateTime? fromDate,
    DateTime? toDate,
    DataPaginator? dataPaginator,
  }) = _WeightRecordDataPaginator;
}
