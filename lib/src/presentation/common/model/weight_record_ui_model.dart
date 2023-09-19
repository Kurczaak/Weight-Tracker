import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_weight_tracker/l10n/l10n.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';

part 'weight_record_ui_model.freezed.dart';

@freezed
class WeightRecordUIModel with _$WeightRecordUIModel {
  const factory WeightRecordUIModel({
    required double weight,
    required DateTime toDate,
    required int? id,
    WeightRecordUIModelType? type,
    DateTime? fromDate,
  }) = _WeightRecordUIModel;
}

enum WeightRecordUIModelType {
  daily,
  weekly,
  monthly;

  bool get isDaily => this == WeightRecordUIModelType.daily;
  bool get isWeekly => this == WeightRecordUIModelType.weekly;
  bool get isMonthly => this == WeightRecordUIModelType.monthly;
}

extension WeighRecordUIModelMappers on WeightRecordUIModel {
  static WeightRecordUIModel fromWeightRecord(WeightRecord weightRecord) =>
      WeightRecordUIModel(
        weight: weightRecord.weight,
        toDate: weightRecord.date,
        id: weightRecord.id,
        type: WeightRecordUIModelType.daily,
      );

  static WeightRecordUIModel fromMeanWeight(MeanWeight meanWeight) =>
      WeightRecordUIModel(
        weight: meanWeight.meanWeight ?? 0,
        toDate: meanWeight.period.toDate,
        fromDate: meanWeight.period.fromDate,
        id: meanWeight.id,
        type: WeightRecordUIModelType.daily,
      );
}

extension WeightRecordUIModelTypeExtension on WeightRecordUIModelType {
  String localizedName(BuildContext context) => switch (this) {
        WeightRecordUIModelType.daily => context.str.records_list__daily,
        WeightRecordUIModelType.weekly => context.str.records_list__weekly,
        WeightRecordUIModelType.monthly => context.str.records_list__monthly,
      };
}
