import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/models/safezone_models.dart';
import 'safezone_repository.dart';

class DemoSafeZoneRepository extends ChangeNotifier implements SafeZoneRepository {
  DemoSafeZoneRepository() {
    _seed();
  }

  final _uuid = const Uuid();
  SafeZoneUser? _currentUser;
  final List<SafeZoneUser> _users = [];
  final List<Incident> _incidents = [];
  final List<FirReport> _firs = [];
  final List<SosLog> _sos = [];
  final List<SafeZoneAlert> _alerts = [];
  final List<SafeZoneNotification> _notifications = [];

  @override
  SafeZoneUser? get currentUser => _currentUser;

  void _seed() {
    if (_users.isNotEmpty) return;
    final now = DateTime.now();
    _users.addAll([
      const SafeZoneUser(id: 'u-resident', displayName: 'Aqib Resident', email: 'resident@safezone.local', role: UserRole.resident),
      const SafeZoneUser(id: 'u-authority', displayName: 'Authority Command', email: 'authority@safezone.local', role: UserRole.authority),
      const SafeZoneUser(id: 'u-admin', displayName: 'Admin Operator', email: 'admin@safezone.local', role: UserRole.admin),
      const SafeZoneUser(id: 'u-super', displayName: 'SuperAdmin Control', email: 'superadmin@safezone.local', role: UserRole.superAdmin),
    ]);
    _incidents.addAll([
      Incident(
        id: 'inc-1',
        number: 'SZ-INC-2401',
        title: 'Suspicious activity near market',
        description: 'Unidentified vehicle circling the block.',
        category: IncidentCategory.suspiciousActivity,
        severity: SeverityLevel.high,
        status: IncidentStatus.pending,
        location: const LatLng(33.6844, 73.0479),
        address: 'Sector 9 Market',
        reportedAt: now.subtract(const Duration(minutes: 18)),
        reporterId: 'u-resident',
      ),
      Incident(
        id: 'inc-2',
        number: 'SZ-INC-2402',
        title: 'Road accident at main signal',
        description: 'Two vehicles involved, traffic blocked.',
        category: IncidentCategory.accident,
        severity: SeverityLevel.critical,
        status: IncidentStatus.inProgress,
        location: const LatLng(33.6901, 73.0551),
        address: 'Main Boulevard',
        reportedAt: now.subtract(const Duration(hours: 1)),
        reporterId: 'u-resident',
        assignedTo: 'Authority Command',
      ),
    ]);
    _firs.add(
      FirReport(
        id: 'fir-1',
        number: 'SZ-FIR-101',
        title: 'Mobile theft complaint',
        complainant: 'Aqib Resident',
        description: 'Phone stolen near bus stop.',
        location: const LatLng(33.6860, 73.0502),
        status: FirStatus.underReview,
        submittedAt: now.subtract(const Duration(days: 1)),
        reporterId: 'u-resident',
        suspect: 'Unknown',
        witness: 'Shopkeeper near stop',
      ),
    );
    _sos.add(
      SosLog(
        id: 'sos-1',
        number: 'SOS-9001',
        type: EmergencyType.police,
        location: const LatLng(33.6847, 73.0442),
        address: 'Block C',
        createdAt: now.subtract(const Duration(minutes: 6)),
        reporterId: 'u-resident',
      ),
    );
    _alerts.add(
      SafeZoneAlert(
        id: 'alert-1',
        title: 'Weather Warning',
        body: 'Heavy rain expected tonight. Avoid low-lying roads.',
        type: AlertType.weatherAlert,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    );
    _notifications.addAll([
      SafeZoneNotification(
        id: 'note-1',
        title: 'Zone Secured',
        body: 'Authority marked Sector 7 secure.',
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      SafeZoneNotification(
        id: 'note-2',
        title: 'FIR Under Review',
        body: 'Your FIR SZ-FIR-101 is being reviewed.',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  @override
  Future<SafeZoneUser> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (password != 'password123') {
      throw StateError('Invalid email or password.');
    }
    _currentUser = _users.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw StateError('Invalid email or password.'),
    );
    notifyListeners();
    return _currentUser!;
  }

  @override
  Future<SafeZoneUser> register(String name, String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final user = SafeZoneUser(id: _uuid.v4(), displayName: name, email: email, role: UserRole.resident);
    _users.add(user);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  @override
  Future<List<Incident>> incidents() async => List.unmodifiable(_incidents);

  @override
  Future<List<Incident>> myIncidents() async {
    final id = _currentUser?.id;
    return _incidents.where((incident) => incident.reporterId == id).toList(growable: false);
  }

  @override
  Future<Incident> createIncident({
    required String title,
    required String description,
    required IncidentCategory category,
    required SeverityLevel severity,
    required double latitude,
    required double longitude,
    required String address,
    required bool anonymous,
  }) async {
    final incident = Incident(
      id: _uuid.v4(),
      number: 'SZ-INC-${2400 + _incidents.length + 1}',
      title: title,
      description: description,
      category: category,
      severity: severity,
      status: IncidentStatus.pending,
      location: LatLng(latitude, longitude),
      address: address,
      reportedAt: DateTime.now(),
      reporterId: _currentUser?.id ?? 'anonymous',
      anonymous: anonymous,
    );
    _incidents.insert(0, incident);
    _notifications.insert(
      0,
      SafeZoneNotification(
        id: _uuid.v4(),
        title: 'Incident Submitted',
        body: '${incident.number} has been sent to command center.',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return incident;
  }

  @override
  bool canMoveIncident(IncidentStatus from, IncidentStatus to) {
    return switch (from) {
      IncidentStatus.pending => to == IncidentStatus.assigned || to == IncidentStatus.inProgress,
      IncidentStatus.assigned => to == IncidentStatus.inProgress || to == IncidentStatus.pending,
      IncidentStatus.inProgress => to == IncidentStatus.resolved || to == IncidentStatus.assigned,
      IncidentStatus.resolved => to == IncidentStatus.closed || to == IncidentStatus.inProgress,
      IncidentStatus.closed => false,
    };
  }

  @override
  Future<Incident> moveIncident(String id, IncidentStatus status) async {
    final index = _incidents.indexWhere((incident) => incident.id == id);
    if (index == -1) throw StateError('Incident not found.');
    final current = _incidents[index];
    if (!canMoveIncident(current.status, status)) {
      throw StateError('Invalid status transition.');
    }
    final updated = current.copyWith(status: status);
    _incidents[index] = updated;
    notifyListeners();
    return updated;
  }

  @override
  Future<List<FirReport>> firs() async => List.unmodifiable(_firs);

  @override
  Future<List<FirReport>> myFirs() async {
    final id = _currentUser?.id;
    return _firs.where((fir) => fir.reporterId == id).toList(growable: false);
  }

  @override
  Future<FirReport> createFir({
    required String title,
    required String complainant,
    required String description,
    required double latitude,
    required double longitude,
    String? suspect,
    String? witness,
    String? lossDamage,
  }) async {
    final fir = FirReport(
      id: _uuid.v4(),
      number: 'SZ-FIR-${100 + _firs.length + 1}',
      title: title,
      complainant: complainant,
      description: description,
      location: LatLng(latitude, longitude),
      status: FirStatus.submitted,
      submittedAt: DateTime.now(),
      reporterId: _currentUser?.id ?? 'anonymous',
      suspect: suspect,
      witness: witness,
      lossDamage: lossDamage,
    );
    _firs.insert(0, fir);
    notifyListeners();
    return fir;
  }

  @override
  Future<FirReport> reviewFir(String id, FirStatus status, String remarks) async {
    final index = _firs.indexWhere((fir) => fir.id == id);
    if (index == -1) throw StateError('FIR not found.');
    final updated = _firs[index].copyWith(status: status, reviewRemarks: remarks);
    _firs[index] = updated;
    notifyListeners();
    return updated;
  }

  @override
  Future<List<SosLog>> sosLogs() async => List.unmodifiable(_sos);

  @override
  Future<SosLog> createSos(EmergencyType type, double latitude, double longitude, String address) async {
    final sos = SosLog(
      id: _uuid.v4(),
      number: 'SOS-${9000 + _sos.length + 1}',
      type: type,
      location: LatLng(latitude, longitude),
      address: address,
      createdAt: DateTime.now(),
      reporterId: _currentUser?.id ?? 'anonymous',
    );
    _sos.insert(0, sos);
    _incidents.insert(
      0,
      Incident(
        id: _uuid.v4(),
        number: 'SZ-INC-${2400 + _incidents.length + 1}',
        title: 'SOS ${type.name}',
        description: 'Critical SOS generated from mobile app.',
        category: IncidentCategory.other,
        severity: SeverityLevel.critical,
        status: IncidentStatus.pending,
        location: LatLng(latitude, longitude),
        address: address,
        reportedAt: DateTime.now(),
        reporterId: _currentUser?.id ?? 'anonymous',
      ),
    );
    notifyListeners();
    return sos;
  }

  @override
  Future<SosLog> markSosHandled(String id) async {
    final index = _sos.indexWhere((sos) => sos.id == id);
    if (index == -1) throw StateError('SOS log not found.');
    final updated = _sos[index].copyWith(handled: true);
    _sos[index] = updated;
    notifyListeners();
    return updated;
  }

  @override
  Future<List<SafeZoneAlert>> alerts() async => List.unmodifiable(_alerts);

  @override
  Future<SafeZoneAlert> broadcastAlert(String title, String body, AlertType type) async {
    final alert = SafeZoneAlert(id: _uuid.v4(), title: title, body: body, type: type, createdAt: DateTime.now());
    _alerts.insert(0, alert);
    notifyListeners();
    return alert;
  }

  @override
  Future<List<SafeZoneNotification>> notifications() async => List.unmodifiable(_notifications);

  @override
  Future<void> markNotificationRead(String id) async {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index == -1) return;
    _notifications[index] = _notifications[index].copyWith(read: true);
    notifyListeners();
  }

  @override
  Future<DashboardStats> stats() async => DashboardStats(
        totalIncidents: _incidents.length,
        activeIncidents: _incidents.where((incident) => incident.status != IncidentStatus.closed).length,
        firsProcessed: _firs.where((fir) => fir.status == FirStatus.accepted || fir.status == FirStatus.closed).length,
        sosHandled: _sos.where((log) => log.handled).length,
        activeAuthorities: _users.where((user) => user.role != UserRole.resident && user.active).length,
      );

  @override
  Future<List<SafeZoneUser>> users() async => List.unmodifiable(_users);

  @override
  Future<SafeZoneUser> toggleUser(String id) async {
    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) throw StateError('User not found.');
    final updated = _users[index].copyWith(active: !_users[index].active);
    _users[index] = updated;
    notifyListeners();
    return updated;
  }
}

