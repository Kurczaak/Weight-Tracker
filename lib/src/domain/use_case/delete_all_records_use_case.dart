import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';

class DeleteAllRecordsUseCase extends UseCaseNoParam<void> {
  DeleteAllRecordsUseCase(this._weightRepository);
  final WeightRepository _weightRepository;

  @override
  Future<void> execute(void param) => _weightRepository.deletAllWeights();
}
