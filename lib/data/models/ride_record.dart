import 'package:isar/isar.dart';

part 'ride_record.g.dart';

@collection
class RideRecord {
  Id id = Isar.autoIncrement;

  late DateTime createdAt;
  late String destination;
  late double fare;
  late double distanceKm;
  late double tolls;
  late double netProfit;
  late String fuelProfile;
  late bool accepted;

  double get grossDriverRevenue => fare * 0.75;
}
