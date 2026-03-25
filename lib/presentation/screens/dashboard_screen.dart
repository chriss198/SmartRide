import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartride/data/models/user_settings.dart';
import 'package:smartride/presentation/providers/app_state.dart';
import 'package:smartride/presentation/screens/history_map_screen.dart';
import 'package:smartride/presentation/screens/settings_screen.dart';
import 'package:smartride/presentation/widgets/hud_overlay.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('SmartRide')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _GaugeCard(todayNetProfit: state.todayNetProfit),
              const SizedBox(height: 16),
              SwitchListTile(
                value: state.settings.isServiceActive,
                onChanged: state.toggleService,
                title: const Text('Service Active'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: FuelProfile.values
                    .map(
                      (profile) => ChoiceChip(
                        label: Text(profile.name.toUpperCase()),
                        selected: state.settings.activeFuelProfile == profile,
                        onSelected: (_) => state.setFuelProfile(profile),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryMapScreen(rides: state.rides),
                    ),
                  );
                },
                child: const Text('Route Map (History)'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                child: const Text('Settings'),
              ),
            ],
          ),
          HudOverlay(result: state.latestResult, destination: state.destination),
        ],
      ),
    );
  }
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.todayNetProfit});

  final double todayNetProfit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Today's Net Profit",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: (todayNetProfit / 80000).clamp(0, 1),
                    strokeWidth: 14,
                  ),
                  Center(
                    child: Text(
                      '\$${todayNetProfit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
