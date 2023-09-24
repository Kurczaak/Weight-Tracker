import 'dart:math';

extension DoubleExtensions on double {
  ({int integerPart, int fractionalPart}) get wholeAndFractional {
    final parts = toString().split('.');
    return (
      integerPart: int.parse(parts.first),
      fractionalPart: int.parse(parts.last)
    );
  }

  double roundTo(int places) {
    final mod = pow(10.0, places);
    return (this * mod).round().toDouble() / mod;
  }

  static double getRandomInRange(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
}
