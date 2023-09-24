import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/presentation/common/model/weight_record_ui_model.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/item_selector.dart';
import 'package:simple_weight_tracker/src/presentation/feature/records_list/notifier/filtered_weights_list/weights_filter_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/records_list/notifier/weights_list/weights_scroll_list_notfier.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';

class RecordsListPage extends ConsumerWidget {
  const RecordsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch(weightsFilterNotifierProvider.notifier);
    final filterState = ref.watch(weightsFilterNotifierProvider);
    final weightsListProvider =
        ref.watch(weightsScrollListNotifierProvider(filterState).notifier);

    final state = ref.watch(weightsScrollListNotifierProvider(filterState));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLarge,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ItemSelector<WeightRecordUIModelType>(
              initialItem: SelectorItem(
                value: WeightRecordUIModelType.weekly,
                name: WeightRecordUIModelType.weekly.localizedName(context),
              ),
              onSelected: (item) {
                filterProvider.selectFilter(item.value);
              },
              items: _buildItems(context),
            ),
          ),
          Expanded(
            child: _RecordsScrollableList(
              state.records,
              weightsListProvider.loadMoreWeightRecords,
            ),
          ),
        ],
      ),
    );
  }

  List<SelectorItem<WeightRecordUIModelType>> _buildItems(
    BuildContext context,
  ) {
    return WeightRecordUIModelType.values
        .map(
          (e) => SelectorItem(
            value: e,
            name: e.localizedName(context),
          ),
        )
        .toList();
  }
}

class _RecordsScrollableList extends HookWidget {
  const _RecordsScrollableList(
    this._records,
    this.onLoadMore,
  );

  final List<WeightRecordUIModel> _records;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent -
                MediaQuery.of(context).size.height) {
          onLoadMore();
        }
      });
      return null;
    });
    if (_records.isEmpty) {
      return const Center(child: Text('No records')); // TODO
    }

    return ListView.builder(
      controller: controller,
      itemCount: _records.length,
      itemBuilder: (context, index) => _WeightRecordListTile(
        _records[index],
        index >= _records.length - 1 ? null : _records[index + 1],
      ),
    );
  }
}

class _WeightRecordListTile extends StatelessWidget {
  const _WeightRecordListTile(this.record, this.previousRecord);

  final WeightRecordUIModel record;
  final WeightRecordUIModel? previousRecord;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.transparent.withOpacity(.08),
      elevation: 0,
      child: ListTile(
        title: Text(
          '${record.weight.toStringAsFixed(1)} kg',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: _RecordDateSection(record: record),
        trailing: previousRecord == null
            ? null
            : _WeightChangeIndicator(
                weightDifference: record.weight - previousRecord!.weight,
              ),
      ),
    );
  }
}

class _RecordDateSection extends StatelessWidget {
  const _RecordDateSection({required this.record});

  final WeightRecordUIModel record;

  @override
  Widget build(BuildContext context) => switch (record.type) {
        WeightRecordUIModelType.weekly => _WeeklyRecordDateSection(
            fromDate: record.fromDate!,
            toDate: record.toDate,
            weekNumber: record.toDate.weekNumber,
          ),
        WeightRecordUIModelType.monthly =>
          _MonthlyRecordDateSection(date: record.toDate),
        _ => _DailyRecordDateSection(date: record.toDate),
      };
}

class _MonthlyRecordDateSection extends StatelessWidget {
  const _MonthlyRecordDateSection({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(date.monthYearFormatted);
  }
}

class _WeeklyRecordDateSection extends StatelessWidget {
  const _WeeklyRecordDateSection({
    required this.fromDate,
    required this.toDate,
    required this.weekNumber,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(fromDate.toFormattedString()),
        const Text(' - '),
        Text(toDate.toFormattedString()),
      ],
    );
  }
}

class _DailyRecordDateSection extends StatelessWidget {
  const _DailyRecordDateSection({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(date.toFormattedString()),
      ],
    );
  }
}

enum WeightChangeStatus {
  gain,
  loss,
  stable;

  bool get isGain => this == WeightChangeStatus.gain;
  bool get isLoss => this == WeightChangeStatus.loss;
  bool get isStable => this == WeightChangeStatus.stable;
}

class _WeightChangeIndicator extends StatelessWidget {
  const _WeightChangeIndicator({required this.weightDifference});

  final double weightDifference;

  WeightChangeStatus get _status {
    if (weightDifference > 0) {
      return WeightChangeStatus.gain;
    } else if (weightDifference < 0) {
      return WeightChangeStatus.loss;
    } else {
      return WeightChangeStatus.stable;
    }
  }

  Color get _statusColor => switch (_status) {
        WeightChangeStatus.gain => AppColors.negativeColor,
        WeightChangeStatus.loss => AppColors.positiveColor,
        WeightChangeStatus.stable => AppColors.neutralColor,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${weightDifference.toStringAsFixed(1)} kg',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _statusColor,
              ),
        ),
        if (!_status.isStable)
          Icon(
            _status.isGain ? Icons.arrow_upward : Icons.arrow_downward,
            color: _statusColor,
          ),
      ],
    );
  }
}
