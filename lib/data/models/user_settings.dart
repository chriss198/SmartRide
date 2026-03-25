import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = 0;

  double fuelPricePerLiter = 1350;
  double minimumProfitPerHour = 6000;
  double appCommissionRate = 0.25;
  bool isServiceActive = false;
  bool isOledNightMode = true;

  @enumerated
  FuelProfile activeFuelProfile = FuelProfile.mixed;

  List<String> safeZones = <String>[];
}

enum FuelProfile { urban, mixed, highway }
