import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartride/presentation/providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final settings = state.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: settings.fuelPricePerLiter.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Fuel Price (CLP/L)'),
          ),
          TextFormField(
            initialValue: settings.minimumProfitPerHour.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Minimum Profit / Hour (CLP)'),
          ),
          TextFormField(
            initialValue: settings.appCommissionRate.toStringAsFixed(2),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'App Commission (0.25 = 25%)'),
          ),
        ],
      ),
    );
  }
}
