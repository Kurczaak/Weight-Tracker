import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_boundaries.freezed.dart';

@freezed
class DateBoundaries with _$DateBoundaries {
  const factory DateBoundaries({
    DateTime? fromDate,
    DateTime? toDate,
  }) = _DateBoundaries;
}
