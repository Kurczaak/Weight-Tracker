import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/mappers/weight_record_mappers.dart';
import 'package:simple_weight_tracker/src/data/repository/weight_repository.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';

class IsarWeightRepositoryImpl implements WeightRepository {
  IsarWeightRepositoryImpl(this._localDao);

  final LocalDao _localDao;

  @override
  Future<void> addWeight(WeightRecord weight) =>
      _localDao.addWeight(weight.toEntity());

  @override
  Future<void> deleteWeight(WeightRecord weight) => _localDao.deleteWeight(
        weight.toEntity(),
      );

  @override
  Future<List<WeightRecord>> getWeights() => _localDao.getAllWeights().then(
        (value) => value.toModelList(),
      );

  @override
  Future<void> updateWeight(WeightRecord weight) => _localDao.updateWeight(
        weight.toEntity(),
      );

  @override
  Future<void> init() => _localDao.init();
}
