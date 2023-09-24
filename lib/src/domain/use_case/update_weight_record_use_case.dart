import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/weight_record.dart';

class UpdateWeightRecordUseCase extends UseCase<void, WeightRecord> {
  UpdateWeightRecordUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<void> execute(WeightRecord param) => _repository.updateWeight(param);
}
