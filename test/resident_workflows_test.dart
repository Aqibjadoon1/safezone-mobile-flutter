import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_mobile/core/models/safezone_enums.dart';
import 'package:safezone_mobile/data/repositories/demo_safezone_repository.dart';

void main() {
  test('FIR submission appears in resident FIR list', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('resident@safezone.local', 'password123');

    final fir = await repo.createFir(
      title: 'Vehicle theft report',
      complainant: 'Aqib Resident',
      description: 'Bike missing from parking area.',
      latitude: 33.6844,
      longitude: 73.0479,
    );

    final mine = await repo.myFirs();
    expect(mine.first.id, fir.id);
  });

  test('SOS creates SOS log and critical incident', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('resident@safezone.local', 'password123');

    await repo.createSos(EmergencyType.fireBrigade, 33.6844, 73.0479, 'Sector 4');

    expect((await repo.sosLogs()).first.type, EmergencyType.fireBrigade);
    expect((await repo.incidents()).first.severity, SeverityLevel.critical);
  });
}

