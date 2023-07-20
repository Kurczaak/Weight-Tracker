import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class WatchInitialWeightUseCase extends UseCaseNoParam<Stream<WeightRecord?>> {
  WatchInitialWeightUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<Stream<WeightRecord?>> execute(void param) async =>
      _repository.watchFirstWeightRecord();
}
