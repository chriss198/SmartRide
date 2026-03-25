import 'package:smartride/data/models/user_settings.dart';
import 'package:smartride/domain/entities/profit_result.dart';

class ProfitCalculator {
  const ProfitCalculator();

  static const Map<FuelProfile, double> fuelConsumption = {
    FuelProfile.urban: 12.5,
    FuelProfile.mixed: 17.1,
    FuelProfile.highway: 20.7,
  };

  ProfitResult evaluate({
    required double fare,
    required double distanceKm,
    required double tolls,
    required String destination,
    required UserSettings settings,
    required double durationMinutes,
  }) {
    final consumoPerfil = fuelConsumption[settings.activeFuelProfile] ?? 17.1;
    final fuelCost = (distanceKm / consumoPerfil) * settings.fuelPricePerLiter;
    final operatingCost = fuelCost * 1.3;

    final driverRevenue = fare * (1 - settings.appCommissionRate);
    final netProfit = driverRevenue - operatingCost - tolls;

    final safeZoneMatch = settings.safeZones
        .map((z) => z.toLowerCase())
        .contains(destination.toLowerCase());

    final hourlyProjection = durationMinutes <= 0
        ? netProfit
        : netProfit * (60 / durationMinutes);

    return ProfitResult(
      netProfit: netProfit,
      operatingCost: operatingCost,
      fuelCost: fuelCost,
      isSafeZone: safeZoneMatch,
      isAboveMinimum: hourlyProjection >= settings.minimumProfitPerHour,
    );
  }
}
