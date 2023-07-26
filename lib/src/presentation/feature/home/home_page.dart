import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/notifier/weight_tracker_notifier.dart';
import 'package:simple_weight_tracker/src/presentation/feature/home/widget/weight_picker_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weightTrackerNotifierProvider);
    final notifier = ref.watch(weightTrackerNotifierProvider.notifier);
    return Scaffold(
      body: _HomePageBody(
        currentRecord: state.firstOrNull,
        firstRecord: state.lastOrNull,
        goalWeight: 80,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFloatingActionButtonPressed(
          context: context,
          weightRecord: state.firstOrNull,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _WeightStatusRow(
          firstRecord: firstRecord,
          currentRecord: currentRecord,
          goalWeight: goalWeight,
        ),
        const _WeightChart(),
        const SizedBox(
          height: 300,
          child: _RecordsList(),
        )
      ],
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
          isHighlighted: true,
        ),
        _WeightStatusCell(
          title: 'Current',
          subtitle: currentRecord?.weight.toStringAsFixed(1) ?? '-',
          isHighlighted: true,
        ),
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
    this.isHighlighted = false,
  });

  final String title;
  final String subtitle;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(
          subtitle,
          style: isHighlighted ? Theme.of(context).textTheme.bodyLarge : null,
        ),
      ],
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Placeholder(),
    );
  }
}

class _RecordsList extends ConsumerWidget {
  const _RecordsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(weightTrackerNotifierProvider);
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
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
