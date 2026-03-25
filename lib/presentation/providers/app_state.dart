import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smartride/data/models/ride_record.dart';
import 'package:smartride/data/models/user_settings.dart';
import 'package:smartride/data/repositories/local_data_source.dart';
import 'package:smartride/domain/entities/profit_result.dart';
import 'package:smartride/domain/usecases/profit_calculator.dart';

class AppState extends ChangeNotifier {
  AppState({required this.dataSource, required this.calculator});

  final LocalDataSource dataSource;
  final ProfitCalculator calculator;

  static const MethodChannel bridge = MethodChannel('cl.smartride/bridge');

  UserSettings settings = UserSettings();
  ProfitResult? latestResult;
  String destination = '-';
  List<RideRecord> rides = const [];

  Future<void> bootstrap() async {
    settings = await dataSource.loadSettings();
    rides = await dataSource.listRides();
    bridge.setMethodCallHandler(_onBridgeEvent);
    notifyListeners();
  }

  Future<void> toggleService(bool value) async {
    settings.isServiceActive = value;
    await dataSource.saveSettings(settings);
    notifyListeners();
  }

  Future<void> setFuelProfile(FuelProfile profile) async {
    settings.activeFuelProfile = profile;
    await dataSource.saveSettings(settings);
    notifyListeners();
  }

  double get todayNetProfit {
    final now = DateTime.now();
    return rides
        .where((r) =>
            r.createdAt.year == now.year &&
            r.createdAt.month == now.month &&
            r.createdAt.day == now.day)
        .fold<double>(0, (sum, ride) => sum + ride.netProfit);
  }

  Future<dynamic> _onBridgeEvent(MethodCall call) async {
    if (call.method != 'onUberOffer') return null;

    final args = Map<String, dynamic>.from(call.arguments as Map);
    final fare = (args['fare'] as num?)?.toDouble() ?? 0;
    final distance = (args['distance'] as num?)?.toDouble() ?? 0;
    final tolls = (args['tolls'] as num?)?.toDouble() ?? 0;
    final durationMin = (args['duration_min'] as num?)?.toDouble() ?? 30;
    destination = args['destination_text']?.toString() ?? '-';

    latestResult = calculator.evaluate(
      fare: fare,
      distanceKm: distance,
      tolls: tolls,
      destination: destination,
      settings: settings,
      durationMinutes: durationMin,
    );

    final ride = RideRecord()
      ..createdAt = DateTime.now()
      ..fare = fare
      ..distanceKm = distance
      ..tolls = tolls
      ..destination = destination
      ..accepted = latestResult!.verdict
      ..fuelProfile = settings.activeFuelProfile.name
      ..netProfit = latestResult!.netProfit;

    await dataSource.saveRide(ride);
    rides = await dataSource.listRides();
    notifyListeners();
    return null;
  }
}
