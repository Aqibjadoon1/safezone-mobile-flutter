import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_mobile/core/models/safezone_enums.dart';
import 'package:safezone_mobile/data/repositories/demo_safezone_repository.dart';

void main() {
  test('demo login returns the requested role user', () async {
    final repo = DemoSafeZoneRepository();

    final user = await repo.login('authority@safezone.local', 'password123');

    expect(user.role, UserRole.authority);
    expect(user.displayName, contains('Authority'));
  });

  test('submitted incident appears in my incidents', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('resident@safezone.local', 'password123');

    final incident = await repo.createIncident(
      title: 'Street light sparks',
      description: 'Electrical sparks near the corner pole.',
      category: IncidentCategory.fire,
      severity: SeverityLevel.high,
      latitude: 33.6844,
      longitude: 73.0479,
      address: 'Sector 7',
      anonymous: false,
    );

    final mine = await repo.myIncidents();
    expect(mine.first.id, incident.id);
    expect(mine.first.title, 'Street light sparks');
  });

  test('kanban transition rejects closed to pending', () {
    final repo = DemoSafeZoneRepository();

    expect(
      repo.canMoveIncident(IncidentStatus.closed, IncidentStatus.pending),
      isFalse,
    );
  });
}
