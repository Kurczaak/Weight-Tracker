import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/common/widget/swt_text_button.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';
import 'package:simple_weight_tracker/src/utils/double_extensions.dart';

class WeightPickerDialog extends HookWidget {
  const WeightPickerDialog({
    required this.onSaved,
    super.key,
    this.initialRecord,
    this.showDateSelector = true,
  });

  final void Function(WeightRecord record) onSaved;
  final WeightRecord? initialRecord;
  final bool showDateSelector;

  @override
  Widget build(BuildContext context) {
    final weightRecord = useState(
      initialRecord ?? WeightRecord(weight: 0, date: DateTime.now()),
    );

    WeightRecord onWeightChanged(double weight) =>
        weightRecord.value = weightRecord.value.copyWith(weight: weight);

    WeightRecord onDateChanged(DateTime date) =>
        weightRecord.value = weightRecord.value.copyWith(date: date);

    return SimpleDialog(
      title: const Text('Add Weight'),
      contentPadding: const EdgeInsets.all(20),
      children: [
        _WeightNumberPickers(
          initialWeight: weightRecord.value.weight,
          onChanged: onWeightChanged,
        ),
        Row(
          children: [
            _DateSelector(
              initialDate: weightRecord.value.date,
              onChanged: onDateChanged,
            ),
            const Spacer(),
            SWTTextButton(
              'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            SWTTextButton(
              'Save  ',
              onPressed: () => _onSavePressed(context, weightRecord.value),
            ),
          ],
        ),
      ],
    );
  }

  void _onSavePressed(BuildContext context, WeightRecord weightRecord) {
    onSaved(weightRecord);
    Navigator.of(context).pop();
  }
}

class _WeightNumberPickers extends HookWidget {
  const _WeightNumberPickers({
    required this.initialWeight,
    required this.onChanged,
  });
  final double initialWeight;
  final void Function(double weight) onChanged;

  @override
  Widget build(BuildContext context) {
    final integerPart = useState(initialWeight.wholeAndFractional.integerPart);
    final fractionalPart =
        useState(initialWeight.wholeAndFractional.fractionalPart);

    double getWeight() =>
        integerPart.value.toDouble() + fractionalPart.value.toDouble() / 10;

    void onIntegerPartChanged(int value) {
      integerPart.value = value;
      onChanged(getWeight());
    }

    void onFractionalPartChanged(int value) {
      fractionalPart.value = value;
      onChanged(getWeight());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NumberPicker(
          minValue: 0,
          maxValue: 999,
          value: integerPart.value,
          onChanged: onIntegerPartChanged,
        ),
        const Text(
          '.',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        _NumberPicker(
          minValue: 0,
          maxValue: 9,
          value: fractionalPart.value,
          onChanged: onFractionalPartChanged,
        ),
      ],
    );
  }
}

class _NumberPicker extends StatelessWidget {
  const _NumberPicker({
    required this.value,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
  });

  final int value;
  final int minValue;
  final int maxValue;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      minValue: minValue,
      maxValue: maxValue,
      value: value,
      onChanged: onChanged,
      selectedTextStyle: Theme.of(context).textTheme.titleLarge,
      itemWidth: 70,
      haptics: true,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.onChanged, this.initialDate});

  final DateTime? initialDate;

  final void Function(DateTime date) onChanged;

  @override
  Widget build(BuildContext context) {
    return SWTTextButton(
      _getDate().toFormattedString(),
      onPressed: () => _openDatePicker(context),
    );
  }

  DateTime _getDate() => initialDate ?? DateTime.now();

  void _openDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _getDate(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        onChanged(date);
      }
    });
  }
}
