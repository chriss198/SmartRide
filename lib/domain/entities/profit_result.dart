class ProfitResult {
  const ProfitResult({
    required this.netProfit,
    required this.operatingCost,
    required this.fuelCost,
    required this.isSafeZone,
    required this.isAboveMinimum,
  });

  final double netProfit;
  final double operatingCost;
  final double fuelCost;
  final bool isSafeZone;
  final bool isAboveMinimum;

  bool get verdict => isSafeZone && isAboveMinimum;
}
