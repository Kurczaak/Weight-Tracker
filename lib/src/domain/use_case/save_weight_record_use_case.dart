import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class SaveWeightRecordUseCase extends UseCase<WeightRecord, WeightRecord> {
  SaveWeightRecordUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<WeightRecord> execute(WeightRecord param) =>
      _repository.addWeight(param);
}
