import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/base_card.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/model/selected_period.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/period_selector.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/weight_chart.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/widget/weight_picker_dialog.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weightTrackerNotifierProvider);
    final notifier = ref.watch(weightTrackerNotifierProvider.notifier)
      ..initWatchWeights(AppConsts.homePageRecordsCount);
    return Scaffold(
      body: _HomePageBody(
        currentRecord: state.latestWeight,
        firstRecord: state.initialWeight,
        goalWeight: 80,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        onPressed: () => _onFloatingActionButtonPressed(
          context: context,
          weightRecord: state.latestWeight,
          onSaved: notifier.addRecord,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed({
    required BuildContext context,
    required WeightRecord? weightRecord,
    required void Function(WeightRecord record) onSaved,
  }) =>
      showDialog<void>(
        context: context,
        builder: (context) => WeightPickerDialog(
          initialRecord: weightRecord?.copyWith(date: DateTime.now()),
          onSaved: onSaved,
        ),
      );
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({
    required this.firstRecord,
    required this.currentRecord,
    required this.goalWeight,
  });

  final WeightRecord? firstRecord;
  final WeightRecord? currentRecord;
  final double goalWeight;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingLarge,
            horizontal: AppDimens.paddingLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WeightStatusRow(
                firstRecord: firstRecord,
                currentRecord: currentRecord,
                goalWeight: goalWeight,
              ),
              AppSpacers.h24,
              const Expanded(child: _WeightChart()),
              AppSpacers.h24,
              BaseCard(
                width: AppDimens.statusCardSize,
                height: AppDimens.statusCardSize,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'GOOD',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: AppColors.positiveColor),
                        ),
                      ),
                    ),
                    Text(
                      'status',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    AppSpacers.h24,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightStatusRow extends StatelessWidget {
  const _WeightStatusRow({
    required this.firstRecord,
    required this.currentRecord,
    required this.goalWeight,
  });

  final WeightRecord? firstRecord;
  final WeightRecord? currentRecord;
  final double goalWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _WeightStatusCell(
          title: 'Start',
          subtitle: firstRecord?.weight.toStringAsFixed(1) ?? '-',
        ),
        AppSpacers.w12,
        _WeightStatusCell(
          title: 'Current',
          subtitle: currentRecord?.weight.toStringAsFixed(1) ?? '-',
        ),
        AppSpacers.w12,
        _WeightStatusCell(
          title: 'Goal',
          subtitle: goalWeight.toStringAsFixed(1),
        ),
      ],
    );
  }
}

class _WeightStatusCell extends StatelessWidget {
  const _WeightStatusCell({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BaseCard(
        padding: const EdgeInsets.symmetric(
          // horizontal: AppDimens.paddingLarge,
          vertical: AppDimens.paddingLarge,
        ),
        child: Column(
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacers.h4,
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightChart extends ConsumerWidget {
  const _WeightChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weightTrackerNotifierProvider);
    return BaseCard(
      height: 300,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLarge,
        vertical: AppDimens.paddingMedium,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: PeriodSelector(
              initiallySelectedPeriod: SelectedPeriod.year,
              onSelected: (selectedPeriod) {},
            ),
          ),
          AppSpacers.h24,
          Expanded(child: WeightChart(weightRecords: state.records))
        ],
      ),
    );
  }
}

class _RecordsList extends ConsumerWidget {
  const _RecordsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weightTrackerNotifierProvider);
    return ListView.builder(
      itemCount: state.records.length,
      itemBuilder: (context, index) {
        final record = state.records[index];
        return ListTile(
          title: Text(record.weight.toString()),
          subtitle: Text(record.date.toString()),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _onPressed(record, ref),
          ),
        );
      },
    );
  }

  void _onPressed(WeightRecord record, WidgetRef ref) {
    ref.watch(weightTrackerNotifierProvider.notifier).removeRecord(record);
  }
}
