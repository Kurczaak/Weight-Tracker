import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao_consts.dart';
import 'package:simple_weight_tracker/src/data/entity/user_config_entity.dart';
import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';

class LocalDaoImpl implements LocalDao {
  LocalDaoImpl(this.isar);

  final Isar isar;

  @override
  Future<WeightRecordEntity> addWeight(WeightRecordEntity weight) =>
      isar.writeTxn(() async {
        final newId = await isar.weightRecordEntitys.put(weight);
        return weight..id = newId;
      });

  @override
  Future<void> deleteWeight(WeightRecordEntity weight) => isar.writeTxn(
        () => weight.id != null
            ? isar.weightRecordEntitys.delete(weight.id!)
            : isar.weightRecordEntitys.deleteByDate(weight.date),
      );

  @override
  Future<List<WeightRecordEntity>> getWeightsBetweenDates({
    int? pageNumber,
    int? pageSize,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final dateQuery = _getWeightsDateQuery(fromDate, toDate);

    return dateQuery
        .sortByDateDesc()
        .offset((pageNumber ?? 0) * (pageSize ?? 0))
        .limit(pageSize ?? 0)
        .findAll();
  }

  @override
  Future<LocalDao> init() async {
    // no-op
    return this;
  }

  static Future<LocalDao> withIsarDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [WeightRecordEntitySchema, UserConfigEntitySchema],
      directory: dir.path,
    );
    return LocalDaoImpl(isar);
  }

  @override
  Future<void> updateWeight(WeightRecordEntity weight) =>
      isar.writeTxn(() => isar.weightRecordEntitys.put(weight));

  @override
  Future<WeightRecordEntity?> getFirstWeightRecord() =>
      isar.weightRecordEntitys.where().sortByDateDesc().findFirst();
  @override
  Future<WeightRecordEntity?> getLastWeightRecord() =>
      isar.weightRecordEntitys.where().sortByDate().findFirst();

  @override
  Stream<WeightRecordEntity?> watchFirstWeightRecord() =>
      isar.weightRecordEntitys
          .where()
          .sortByDate()
          .watch(fireImmediately: true)
          .map((event) => event.isNotEmpty ? event.first : null);

  @override
  Stream<WeightRecordEntity?> watchLastWeightRecord() =>
      isar.weightRecordEntitys
          .where()
          .sortByDateDesc()
          .watch(fireImmediately: true)
          .map((event) => event.isNotEmpty ? event.first : null);

  @override
  Stream<List<WeightRecordEntity>> watchWeights({
    DateTime? fromDate,
    DateTime? toDate,
    int? pageNumber,
    int? pageSize,
  }) {
    final dateQuery = _getWeightsDateQuery(fromDate, toDate);

    return dateQuery
        .sortByDateDesc()
        .offset((pageNumber ?? 0) * (pageSize ?? 0))
        .limit(pageSize ?? LocalDaoConsts.maxRecordsCount)
        .watch(fireImmediately: true);
  }

  QueryBuilder<WeightRecordEntity, WeightRecordEntity, QAfterWhereClause>
      _getWeightsDateQuery(DateTime? fromDate, DateTime? toDate) {
    QueryBuilder<WeightRecordEntity, WeightRecordEntity, QAfterWhereClause>
        dateQuery;
    final weightsWhereQuery = isar.weightRecordEntitys.where();
    if (fromDate != null) {
      dateQuery = weightsWhereQuery.dateGreaterThan(fromDate);
    }
    if (toDate != null) {
      dateQuery = weightsWhereQuery.dateLessThan(toDate);
    }
    if (fromDate != null && toDate != null) {
      dateQuery = weightsWhereQuery.dateBetween(fromDate, toDate);
    } else {
      dateQuery =
          weightsWhereQuery.dateGreaterThan(AppConsts.oldestPossibleDate);
    }
    return dateQuery;
  }

  @override
  Future<UserConfigEntity?> getUserConfig() => isar.userConfigEntitys.get(0);

  @override
  Future<void> saveUserConfig(UserConfigEntity userConfig) =>
      isar.writeTxn(() async {
        await isar.userConfigEntitys.put(userConfig);
      });
}
