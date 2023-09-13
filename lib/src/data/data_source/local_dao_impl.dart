import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao.dart';
import 'package:simple_weight_tracker/src/data/data_source/local_dao_consts.dart';
import 'package:simple_weight_tracker/src/data/entity/mean_weight_entity.dart';
import 'package:simple_weight_tracker/src/data/entity/user_config_entity.dart';
import 'package:simple_weight_tracker/src/data/entity/weight_record_entity.dart';
import 'package:simple_weight_tracker/src/data/mappers/weight_record_mappers.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';

class LocalDaoImpl implements LocalDao {
  LocalDaoImpl(this.isar);

  final Isar isar;

  @override
  Future<WeightRecordEntity> addWeight(WeightRecordEntity weight) =>
      isar.writeTxn(() async {
        final newId = await isar.weightRecordEntitys.put(weight);
        await _handleUpdateWeeklyMeanWeight(weight);
        await _handleUpdateMonthlyMeanWeight(weight);
        return weight..id = newId;
      });

  @override
  Future<void> deleteWeight(WeightRecordEntity weight) => isar.writeTxn(() {
        weight.id != null
            ? isar.weightRecordEntitys.delete(weight.id!)
            : isar.weightRecordEntitys.deleteByDate(weight.date);

        _deleteWeightRecordFromWeeklyMeanWeight(weight);
        return _deleteWeightRecordFromMonthlyMeanWeight(weight);
      });

  @override
  Future<void> deleteAllWeights() => isar.writeTxn(
        () => isar.weightRecordEntitys.clear(),
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

  /// Updates the weekly mean weight entity with the new weight record if
  /// a weekly mean weight entity exists for the week of the weight record.
  /// If a weekly mean weight entity does not exist for the week of the weight
  /// record, a new weekly mean weight entity is created with the weight record.
  Future<void> _handleUpdateWeeklyMeanWeight(WeightRecordEntity weight) async {
    var weeklyMeanWeight = await isar.weeklyMeanWeightEntitys
        .get(_getWeeklyMeanWeightId(weight.date));
    if (weeklyMeanWeight != null) {
      _updateWeightRecordInWeeklyMeanWeight(weeklyMeanWeight, weight);
    } else {
      weeklyMeanWeight = WeeklyMeanWeightEntity(
        id: _getWeeklyMeanWeightId(weight.date),
        weightRecords: [weight.toEmbededModel()],
      );
    }
    await isar.weeklyMeanWeightEntitys.put(weeklyMeanWeight);
  }

  // Updates the weight record in the weekly mean weight entity if the weight
  // record exists in the weekly mean weight entity.
  void _updateWeightRecordInWeeklyMeanWeight(
    WeeklyMeanWeightEntity weeklyMeanWeight,
    WeightRecordEntity weight,
  ) {
    final record = weeklyMeanWeight.weightRecords
        .firstWhereOrNull((element) => element.id == weight.id);
    if (record != null) {
      weeklyMeanWeight.weightRecords.remove(record);
    }
    weeklyMeanWeight.weightRecords.add(weight.toEmbededModel());
  }

  /// Updates the monthly mean weight entity with the new weight record if
  /// a monthly mean weight entity exists for the week of the weight record.
  /// If a monthly mean weight entity does not exist for the week of the weight
  /// record, a new monthly mean weight entity is created with the weight record.
  Future<void> _handleUpdateMonthlyMeanWeight(WeightRecordEntity weight) async {
    var monthlyMeanWeight = await isar.monthlyMeanWeightEntitys
        .get(_getMonthlyMeanWeightId(weight.date));
    if (monthlyMeanWeight != null) {
      _updateWeightRecordInMonthlyMeanWeight(monthlyMeanWeight, weight);
    } else {
      monthlyMeanWeight = MonthlyMeanWeightEntity(
        id: _getMonthlyMeanWeightId(weight.date),
        weightRecords: [weight.toEmbededModel()],
      );
    }
    await isar.monthlyMeanWeightEntitys.put(monthlyMeanWeight);
  }

  // Updates the weight record in the monthly mean weight entity if the weight
  // record exists in the monthly mean weight entity.
  void _updateWeightRecordInMonthlyMeanWeight(
    MonthlyMeanWeightEntity monthlyMeanWeight,
    WeightRecordEntity weight,
  ) {
    final record = monthlyMeanWeight.weightRecords
        .firstWhereOrNull((element) => element.id == weight.id);
    if (record != null) {
      monthlyMeanWeight.weightRecords.remove(record);
    }
    monthlyMeanWeight.weightRecords.add(weight.toEmbededModel());
  }

  /// Deletes the weight record from the weekly mean weight entity if
  /// a weekly mean weight entity exists for the week of the weight record.
  Future<void> _deleteWeightRecordFromWeeklyMeanWeight(
    WeightRecordEntity weight,
  ) async {
    final weeklyMeanWeight = await isar.weeklyMeanWeightEntitys
        .get(_getWeeklyMeanWeightId(weight.date));
    if (weeklyMeanWeight == null) return;

    final record = weeklyMeanWeight.weightRecords
        .firstWhereOrNull((element) => element.id == weight.id);
    if (record != null) {
      weeklyMeanWeight.weightRecords.remove(record);
    }
    if (weeklyMeanWeight.weightRecords.isEmpty) {
      await isar.weeklyMeanWeightEntitys.delete(weeklyMeanWeight.id!);
    }
  }

  /// Deletes the weight record from the monthly mean weight entity if
  /// a monthly mean weight entity exists for the week of the weight record.
  Future<void> _deleteWeightRecordFromMonthlyMeanWeight(
    WeightRecordEntity weight,
  ) async {
    final monthlyMeanWeight = await isar.monthlyMeanWeightEntitys
        .get(_getMonthlyMeanWeightId(weight.date));

    if (monthlyMeanWeight == null) return;

    final record = monthlyMeanWeight.weightRecords
        .firstWhereOrNull((element) => element.id == weight.id);
    if (record != null) {
      monthlyMeanWeight.weightRecords.remove(record);
    }
    if (monthlyMeanWeight.weightRecords.isEmpty) {
      await isar.monthlyMeanWeightEntitys.delete(monthlyMeanWeight.id!);
    }
  }

  int _getWeeklyMeanWeightId(DateTime date) =>
      date.year * 100 + date.weekNumber;

  int _getMonthlyMeanWeightId(DateTime date) => date.year * 100 + date.month;

  @override
  Stream<List<MonthlyMeanWeightEntity>?> getMonthlyMeanWeights() =>
      isar.monthlyMeanWeightEntitys.where().watch();
  @override
  Stream<List<WeeklyMeanWeightEntity>?> getWeeklyMeanWeights() =>
      isar.weeklyMeanWeightEntitys.where().watch();
}
