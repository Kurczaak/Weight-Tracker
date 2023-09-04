import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/l10n/l10n.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/base_card.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/model/selected_period.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/notifier/period_selector_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/period_selector/period_selector.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/weight_chart.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/fitlered_weight_tracker/filtered_weight_tracker_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker/weight_tracker_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/widget/weight_picker_dialog.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_colors.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      weightTrackerNotifierProvider(null),
    );
    final notifier = ref.watch(
      weightTrackerNotifierProvider(null).notifier,
    );
    return Scaffold(
      body: _HomePageBody(
        currentRecord: state.latestWeight,
        firstRecord: state.initialWeight,
        goalWeight: state.goalWeight,
        onGoalWeightSelected: notifier.saveGoalWeight,
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
    required this.onGoalWeightSelected,
  });

  final WeightRecord? firstRecord;
  final WeightRecord? currentRecord;
  final double? goalWeight;
  final void Function(double weight) onGoalWeightSelected;

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
                onGoalWeightSelected: onGoalWeightSelected,
              ),
              AppSpacers.h24,
              const _WeightChart(),
              AppSpacers.h24,
              const _ProgressStatus(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStatus extends StatelessWidget {
  const _ProgressStatus();

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      width: AppDimens.statusCardSize,
      height: AppDimens.statusCardSize,
      child: Column(
        children: [
          // TODO handle different statuses
          Expanded(
            child: Center(
              child: Text(
                context.str.status__good,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: AppColors.positiveColor),
              ),
            ),
          ),
          Text(
            context.str.status__status,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          AppSpacers.h24,
        ],
      ),
    );
  }
}

class _WeightStatusRow extends ConsumerWidget {
  const _WeightStatusRow({
    required this.firstRecord,
    required this.currentRecord,
    required this.goalWeight,
    required this.onGoalWeightSelected,
  });

  final WeightRecord? firstRecord;
  final WeightRecord? currentRecord;
  final double? goalWeight;
  final void Function(double weight) onGoalWeightSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _WeightStatusCell(
          title: context.str.general__start,
          subtitle: firstRecord?.weight.toStringAsFixed(1),
        ),
        AppSpacers.w12,
        _WeightStatusCell(
          title: context.str.general__current,
          subtitle: currentRecord?.weight.toStringAsFixed(1),
        ),
        AppSpacers.w12,
        _WeightStatusCell(
          title: context.str.general__goal,
          subtitle: goalWeight?.toStringAsFixed(1),
          onTap: () => _onAddGoalWegith(context),
        ),
      ],
    );
  }

  void _onAddGoalWegith(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => WeightPickerDialog(
          showDateSelector: false,
          initialRecord: WeightRecord(
            weight: goalWeight ?? currentRecord?.weight ?? 0,
            date: DateTime.now(),
          ),
          onSaved: (record) {
            onGoalWeightSelected(record.weight);
          },
        ),
      );
}

class _WeightStatusCell extends StatelessWidget {
  const _WeightStatusCell({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: BaseCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingLarge,
          ),
          child: Column(
            children: [
              Text(
                subtitle ?? AppConsts.emptyPlaceholder,
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
      ),
    );
  }
}

class _WeightChart extends ConsumerWidget {
  const _WeightChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filteredWeightTrackerProvider);

    final notifier = ref.watch(
      periodSelectorNotifierProvider.notifier,
    );
    return Expanded(
      child: BaseCard(
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
                initiallySelectedPeriod: SelectedPeriod.month,
                onSelected: notifier.selectPeriod,
              ),
            ),
            AppSpacers.h24,
            Expanded(
              child: WeightChart(
                weightRecords: state,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
