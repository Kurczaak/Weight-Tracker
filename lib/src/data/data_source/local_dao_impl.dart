import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';

class LocalDaoImpl implements LocalDao {
  late Isar isar;

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
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [WeightRecordEntitySchema],
      directory: dir.path,
    );
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
          .sortByDateDesc()
          .watch(fireImmediately: true)
          .map((event) => event.first);

  @override
  Stream<WeightRecordEntity?> watchLastWeightRecord() =>
      isar.weightRecordEntitys
          .where()
          .sortByDate()
          .watch(fireImmediately: true)
          .map((event) => event.first);

  @override
  Stream<List<WeightRecordEntity>> watchWeightsBetweenDates({
    DateTime? fromDate,
    DateTime? toDate,
    int? pageNumber,
    int? pageSize,
  }) {
    final dateQuery = _getWeightsDateQuery(fromDate, toDate);

    return dateQuery
        .sortByDateDesc()
        .offset((pageNumber ?? 0) * (pageSize ?? 0))
        .limit(pageSize ?? 0)
        .watch(fireImmediately: true)
        .map((event) => event.toList());
  }

  QueryBuilder<WeightRecordEntity, WeightRecordEntity, QAfterWhereClause>
      _getWeightsDateQuery(DateTime? fromDate, DateTime? toDate) {
    late QueryBuilder<WeightRecordEntity, WeightRecordEntity, QAfterWhereClause>
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
    }
    return dateQuery;
  }
}
