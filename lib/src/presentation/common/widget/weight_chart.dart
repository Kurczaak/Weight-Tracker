import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_weight_tracker/src/domain/model/weight_record.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_consts.dart';
import 'package:simple_weight_tracker/src/presentation/styleguide/app_dimens.dart';
import 'package:simple_weight_tracker/src/utils/date_time_extensions.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({
    required this.weightRecords,
    super.key,
    this.minWeight,
    this.maxWeight,
    this.goalWeight,
    this.meanWeight,
  });
  final List<WeightRecord> weightRecords;
  final double? minWeight;
  final double? maxWeight;
  final double? goalWeight;
  final double? meanWeight;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: maxWeight,
        minY: minWeight,
        minX: 0,
        maxX: weightRecords.length - 1.0,
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: _buildTitlesData(context),
        lineBarsData: [
          _buildWeightRecordsBarData(),
        ],
      ),
    );
  }

  double _screenWidthToXAxisPointsCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < AppConsts.mobileScreenWidth) {
      return AppConsts.mobileXAxisPointsCount;
    } else if (screenWidth < AppConsts.tabletScreenWidth) {
      return AppConsts.tabletXAxisPointsCount;
    } else {
      return AppConsts.desktopXAxisPointsCount;
    }
  }

  double _screenWidthToInterval(BuildContext context) {
    final interval =
        weightRecords.length / _screenWidthToXAxisPointsCount(context);
    if (interval < 1) {
      return 1;
    }

    return interval;
  }

  LineChartBarData _buildWeightRecordsBarData() {
    return LineChartBarData(
      spots: _mapWeightRecordsToSpots(),
      isCurved: true,
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      bottomTitles: _buildBottomTitles(context),
      leftTitles: _buildLeftTitles(),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
    );
  }

  AxisTitles _buildLeftTitles() {
    return const AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: _buildLeftTitleWidgets,
        reservedSize: AppDimens.weightChartTitleReservedSize,
      ),
    );
  }

  AxisTitles _buildBottomTitles(BuildContext context) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: _screenWidthToInterval(context),
        getTitlesWidget: _buildBottomTitleWidgets,
        reservedSize: AppDimens.weightChartTitleReservedSize,
      ),
    );
  }

  List<FlSpot> _mapWeightRecordsToSpots() {
    return weightRecords
        .mapIndexed(
          (index, element) => FlSpot(index.toDouble(), element.weight),
        )
        .toList();
  }

  Widget _buildBottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    final index = value.toInt();

    return SideTitleWidget(
      space: AppDimens.bottomTitleWidgetSpace,
      axisSide: meta.axisSide,
      child: Text(
        weightRecords[index].date.toShortFormat(),
        style: style,
      ),
    );
  }
}

Widget _buildLeftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  return Text(
    value.toStringAsFixed(1),
    style: style,
    textAlign: TextAlign.left,
  );
}
