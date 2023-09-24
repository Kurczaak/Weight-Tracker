import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/base/base_use_case.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';

class GetMeanRecordsUseCase
    extends UseCase<Stream<List<MeanWeight>>, MeanWeightType> {
  GetMeanRecordsUseCase(this._repository);

  final WeightRepository _repository;

  @override
  Future<Stream<List<MeanWeight>>> execute(MeanWeightType param) async =>
      param == MeanWeightType.month
          ? _repository.watchMontlyMeanWeights()
          : _repository.watchWeeklyMeanWeights();
}
