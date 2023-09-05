import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/utils/double_extensions.dart';

/// Debug purposes only
/// Generates random records given a number of days
class GenerateRandomRecordsUseCase extends UseCase<void, int> {
  GenerateRandomRecordsUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<void> execute(int param) async {
    var a = 0.0;
    for (var i = 0; i < param; i++) {
      final randomProgress = DoubleExtensions.getRandomInRange(-.5, .5);
      a += randomProgress;
      if (i.isEven) {
        await _repository.addWeight(
          WeightRecord(
            weight: 80 + a.roundTo(1),
            date: DateTime.now().subtract(Duration(days: i)),
          ),
        );
      }
    }
  }
}
