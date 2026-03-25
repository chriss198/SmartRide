import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartride/core/theme/app_theme.dart';
import 'package:smartride/data/repositories/local_data_source.dart';
import 'package:smartride/domain/usecases/profit_calculator.dart';
import 'package:smartride/presentation/providers/app_state.dart';
import 'package:smartride/presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataSource = await LocalDataSource.create();
  runApp(SmartRideApp(dataSource: dataSource));
}

class SmartRideApp extends StatelessWidget {
  const SmartRideApp({super.key, required this.dataSource});

  final LocalDataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalDataSource>.value(value: dataSource),
        Provider<ProfitCalculator>(create: (_) => const ProfitCalculator()),
        ChangeNotifierProvider(
          create: (context) => AppState(
            dataSource: context.read<LocalDataSource>(),
            calculator: context.read<ProfitCalculator>(),
          )..bootstrap(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (_, state, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SmartRide',
            theme: AppTheme.dayTheme,
            darkTheme: AppTheme.nightTheme,
            themeMode: state.settings.isOledNightMode ? ThemeMode.dark : ThemeMode.light,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
