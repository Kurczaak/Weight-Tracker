import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class DeleteWeightRecordUseCase extends UseCase<void, WeightRecord> {
  DeleteWeightRecordUseCase(this._weightRepository);
  final WeightRepository _weightRepository;

  @override
  Future<void> execute(WeightRecord param) =>
      _weightRepository.deleteWeight(param);
}
