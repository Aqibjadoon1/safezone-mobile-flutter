import '../../core/models/safezone_enums.dart';
import '../../core/models/safezone_models.dart';

abstract class SafeZoneRepository {
  SafeZoneUser? get currentUser;

  Future<SafeZoneUser> login(String email, String password);
  Future<SafeZoneUser> register(String name, String email, String password);
  Future<void> logout();

  Future<List<Incident>> incidents();
  Future<List<Incident>> myIncidents();
  Future<Incident> createIncident({
    required String title,
    required String description,
    required IncidentCategory category,
    required SeverityLevel severity,
    required double latitude,
    required double longitude,
    required String address,
    required bool anonymous,
  });
  bool canMoveIncident(IncidentStatus from, IncidentStatus to);
  Future<Incident> moveIncident(String id, IncidentStatus status);

  Future<List<FirReport>> firs();
  Future<List<FirReport>> myFirs();
  Future<FirReport> createFir({
    required String title,
    required String complainant,
    required String description,
    required double latitude,
    required double longitude,
    String? suspect,
    String? witness,
    String? lossDamage,
  });
  Future<FirReport> reviewFir(String id, FirStatus status, String remarks);

  Future<List<SosLog>> sosLogs();
  Future<SosLog> createSos(
      EmergencyType type, double latitude, double longitude, String address);
  Future<SosLog> markSosHandled(String id);

  Future<List<SafeZoneAlert>> alerts();
  Future<SafeZoneAlert> broadcastAlert(
      String title, String body, AlertType type);
  Future<List<SafeZoneNotification>> notifications();
  Future<void> markNotificationRead(String id);
  Future<DashboardStats> stats();
  Future<List<SafeZoneUser>> users();
  Future<SafeZoneUser> toggleUser(String id);
}
