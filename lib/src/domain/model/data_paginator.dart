import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_paginator.freezed.dart';

@freezed
class DataPaginator with _$DataPaginator {
  const factory DataPaginator({
    required int pageNumber,
    required int pageSize,
  }) = _DataPaginator;
}
