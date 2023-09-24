import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/export_model.dart';
import 'package:simple_weight_tracker/src/domain/model/weight/mean_weight.dart';
import 'package:simple_weight_tracker/src/domain/use_case/export_use_case.dart';
import 'package:simple_weight_tracker/src/domain/use_case/provider/use_case_provider.dart';
import 'package:simple_weight_tracker/src/presentation/common/model/weight_record_ui_model.dart';
import 'package:simple_weight_tracker/src/presentation/feature/records_list/notifier/weights_list/weights_scroll_list_state.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/utils/debouncer.dart';
import 'package:simple_weight_tracker/src/utils/weight_record_extensions.dart';

final weightsScrollListNotifierProvider = StateNotifierProvider.family<
    WeightsScrollListNotifier,
    WeightsScrollListState,
    WeightRecordUIModelType>((ref, type) {
  final watchWeightRecordsUseCase =
      ref.watch(watchWeightRecordsUseCaseProvider);
  final getMeanRecordsUseCase = ref.watch(getMeanRecordsUseCaseProvider);

  return WeightsScrollListNotifier(
    watchWeightRecordsUseCase,
    getMeanRecordsUseCase,
    type,
  );
});

class WeightsScrollListNotifier extends StateNotifier<WeightsScrollListState> {
  WeightsScrollListNotifier(
    this._watchWeightRecordsUseCase,
    this._getMeanRecordsUseCase,
    this._type,
  ) : super(const WeightsScrollListState()) {
    if (_type == WeightRecordUIModelType.daily) {
      watchDailyWeightRecords(
        pageNumber: pageNumber,
        pageSize: AppConsts.recordsListPageSize,
      );
    } else {
      watchMeanRecord(_type);
    }
  }

  final WatchWeightRecordsUseCase _watchWeightRecordsUseCase;
  final GetMeanRecordsUseCase _getMeanRecordsUseCase;
  final WeightRecordUIModelType _type;
  final debouncer = Debouncer(AppConsts.debouncerDuration.inMilliseconds);
  int pageNumber = 0;

  Future<void> loadMoreWeightRecords() async {
    if (state.isLoading || !_type.isDaily) return;

    state = state.copyWith(isLoading: true);
    pageNumber++;
    debouncer.debounce(() async {
      await watchDailyWeightRecords(
        pageNumber: pageNumber,
        pageSize: AppConsts.recordsListPageSize,
      );
    });
  }

  Future<void> watchDailyWeightRecords({
    required int pageNumber,
    required int pageSize,
  }) async {
    state = state.copyWith(isLoading: true);

    final latestRecords = await _watchWeightRecordsUseCase(
      WeightRecordDataPaginator(
        dataPaginator: DataPaginator(
          pageNumber: pageNumber,
          pageSize: pageSize,
        ),
      ),
    );

    latestRecords.fold(
      (l) {
        state = state.copyWith(
          records: [],
          isLoading: false,
        );
      },
      (r) => r.listen((event) async {
        state = state.copyWith(
          records: [
            if (pageNumber != 0) ...state.records,
            ..._mapDailyRecordsToUIModel(event),
          ],
          isLoading: false,
        );
      }),
    );
  }

  Future<void> watchMeanRecord(WeightRecordUIModelType meanWeightType) async {
    state = state.copyWith(isLoading: true);

    final meanWeight =
        await _getMeanRecordsUseCase(meanWeightType.toMeanWeightType());

    meanWeight.fold(
      (l) => state = state.copyWith(
        records: [],
        isLoading: false,
      ),
      (r) => r.listen((event) async {
        state = state.copyWith(
          records: _mapMeanWeightsToUIModel(
            event,
            meanWeightType,
          ),
        );
      }),
    );
  }

  List<WeightRecordUIModel> _mapDailyRecordsToUIModel(
    List<WeightRecord> records,
  ) =>
      records
          .map(
            (item) => WeighRecordUIModelMappers.fromWeightRecord(item)
                .copyWith(type: WeightRecordUIModelType.daily),
          )
          .toList()
          .orderedByDate;

  List<WeightRecordUIModel> _mapMeanWeightsToUIModel(
    List<MeanWeight> meanWeights,
    WeightRecordUIModelType type,
  ) {
    return meanWeights
        .map(
          (item) => WeighRecordUIModelMappers.fromMeanWeight(item)
              .copyWith(type: type),
        )
        .toList()
        .orderedByDate;
  }
}
