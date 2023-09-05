import 'dart:math';

import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

/// Debug purposes only
/// Generates random records given a number of days
class GenerateRandomRecordsUseCase extends UseCase<void, int> {
  GenerateRandomRecordsUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<void> execute(int param) async {
    var a = 0.0;
    for (var i = 0; i < param; i++) {
      final random = Random();
      a += random.nextDouble() - .5;

      await _repository.addWeight(
        WeightRecord(
          weight: 80 + a,
          date: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
  }
}
