enum SelectedPeriod {
  month(1),
  quarterly(3),
  halfYear(6),
  year(12),
  begining(null);

  const SelectedPeriod(this.monthsCount);

  final int? monthsCount;
}
