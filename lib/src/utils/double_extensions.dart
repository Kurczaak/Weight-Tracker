extension DoubleExtensions on double {
  ({int integerPart, int fractionalPart}) get wholeAndFractional {
    final parts = toString().split('.');
    return (
      integerPart: int.parse(parts.first),
      fractionalPart: int.parse(parts.last)
    );
  }
}
