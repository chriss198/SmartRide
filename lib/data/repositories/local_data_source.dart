import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartride/data/models/ride_record.dart';
import 'package:smartride/data/models/user_settings.dart';

class LocalDataSource {
  LocalDataSource(this.isar);

  final Isar isar;

  static Future<LocalDataSource> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [RideRecordSchema, UserSettingsSchema],
      directory: dir.path,
    );
    return LocalDataSource(isar);
  }

  Future<UserSettings> loadSettings() async {
    final existing = await isar.userSettings.get(0);
    if (existing != null) return existing;

    final defaults = UserSettings()..safeZones.addAll(_defaultCommunes);
    await isar.writeTxn(() async => isar.userSettings.put(defaults));
    return defaults;
  }

  Future<void> saveSettings(UserSettings settings) async {
    await isar.writeTxn(() async => isar.userSettings.put(settings));
  }

  Future<void> saveRide(RideRecord ride) async {
    await isar.writeTxn(() async => isar.rideRecords.put(ride));
  }

  Future<List<RideRecord>> listRides() async {
    return isar.rideRecords.where().sortByCreatedAtDesc().findAll();
  }

  static const List<String> _defaultCommunes = [
    'Cerrillos',
    'Cerro Navia',
    'Conchalí',
    'El Bosque',
    'Estación Central',
    'Huechuraba',
    'Independencia',
    'La Cisterna',
    'La Florida',
    'La Granja',
    'La Pintana',
    'La Reina',
    'Las Condes',
    'Lo Barnechea',
    'Lo Espejo',
    'Lo Prado',
    'Macul',
    'Maipú',
    'Ñuñoa',
    'Pedro Aguirre Cerda',
    'Peñalolén',
    'Providencia',
    'Pudahuel',
    'Quilicura',
    'Quinta Normal',
    'Recoleta',
    'Renca',
    'San Joaquín',
    'San Miguel',
    'San Ramón',
    'Santiago Centro',
    'Vitacura',
    'Puente Alto',
    'Pirque',
    'San José de Maipo',
    'Padre Hurtado',
    'Colina',
    'Curacaví',
    'Melipilla',
    'Buin',
  ];
}
