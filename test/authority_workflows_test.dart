import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_mobile/core/models/safezone_enums.dart';
import 'package:safezone_mobile/data/repositories/demo_safezone_repository.dart';

void main() {
  test('authority can move pending incident to assigned', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('authority@safezone.local', 'password123');
    final pending = (await repo.incidents())
        .firstWhere((item) => item.status == IncidentStatus.pending);

    final updated =
        await repo.moveIncident(pending.id, IncidentStatus.assigned);

    expect(updated.status, IncidentStatus.assigned);
  });

  test('FIR review stores status and remarks', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('authority@safezone.local', 'password123');
    final fir = (await repo.firs()).first;

    final updated = await repo.reviewFir(
        fir.id, FirStatus.accepted, 'Verified by desk officer.');

    expect(updated.status, FirStatus.accepted);
    expect(updated.reviewRemarks, 'Verified by desk officer.');
  });

  test('SOS can be marked handled', () async {
    final repo = DemoSafeZoneRepository();
    await repo.login('authority@safezone.local', 'password123');
    final sos = (await repo.sosLogs()).first;

    final updated = await repo.markSosHandled(sos.id);

    expect(updated.handled, isTrue);
  });
}
