import 'package:latlong2/latlong.dart';

import 'safezone_enums.dart';

class SafeZoneUser {
  const SafeZoneUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.active = true,
  });

  final String id;
  final String displayName;
  final String email;
  final UserRole role;
  final bool active;

  SafeZoneUser copyWith({bool? active, UserRole? role}) => SafeZoneUser(
        id: id,
        displayName: displayName,
        email: email,
        role: role ?? this.role,
        active: active ?? this.active,
      );
}

class Incident {
  const Incident({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.status,
    required this.location,
    required this.address,
    required this.reportedAt,
    required this.reporterId,
    this.anonymous = false,
    this.assignedTo,
    this.responseNote,
  });

  final String id;
  final String number;
  final String title;
  final String description;
  final IncidentCategory category;
  final SeverityLevel severity;
  final IncidentStatus status;
  final LatLng location;
  final String address;
  final DateTime reportedAt;
  final String reporterId;
  final bool anonymous;
  final String? assignedTo;
  final String? responseNote;

  Incident copyWith({
    IncidentStatus? status,
    String? assignedTo,
    String? responseNote,
  }) =>
      Incident(
        id: id,
        number: number,
        title: title,
        description: description,
        category: category,
        severity: severity,
        status: status ?? this.status,
        location: location,
        address: address,
        reportedAt: reportedAt,
        reporterId: reporterId,
        anonymous: anonymous,
        assignedTo: assignedTo ?? this.assignedTo,
        responseNote: responseNote ?? this.responseNote,
      );
}

class FirReport {
  const FirReport({
    required this.id,
    required this.number,
    required this.title,
    required this.complainant,
    required this.description,
    required this.location,
    required this.status,
    required this.submittedAt,
    required this.reporterId,
    this.suspect,
    this.witness,
    this.lossDamage,
    this.reviewRemarks,
  });

  final String id;
  final String number;
  final String title;
  final String complainant;
  final String description;
  final LatLng location;
  final FirStatus status;
  final DateTime submittedAt;
  final String reporterId;
  final String? suspect;
  final String? witness;
  final String? lossDamage;
  final String? reviewRemarks;

  FirReport copyWith({FirStatus? status, String? reviewRemarks}) => FirReport(
        id: id,
        number: number,
        title: title,
        complainant: complainant,
        description: description,
        location: location,
        status: status ?? this.status,
        submittedAt: submittedAt,
        reporterId: reporterId,
        suspect: suspect,
        witness: witness,
        lossDamage: lossDamage,
        reviewRemarks: reviewRemarks ?? this.reviewRemarks,
      );
}

class SosLog {
  const SosLog({
    required this.id,
    required this.number,
    required this.type,
    required this.location,
    required this.address,
    required this.createdAt,
    required this.reporterId,
    this.handled = false,
  });

  final String id;
  final String number;
  final EmergencyType type;
  final LatLng location;
  final String address;
  final DateTime createdAt;
  final String reporterId;
  final bool handled;

  SosLog copyWith({bool? handled}) => SosLog(
        id: id,
        number: number,
        type: type,
        location: location,
        address: address,
        createdAt: createdAt,
        reporterId: reporterId,
        handled: handled ?? this.handled,
      );
}

class SafeZoneAlert {
  const SafeZoneAlert({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final AlertType type;
  final DateTime createdAt;
}

class SafeZoneNotification {
  const SafeZoneNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  SafeZoneNotification copyWith({bool? read}) => SafeZoneNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        read: read ?? this.read,
      );
}

class DashboardStats {
  const DashboardStats({
    required this.totalIncidents,
    required this.activeIncidents,
    required this.firsProcessed,
    required this.sosHandled,
    required this.activeAuthorities,
  });

  final int totalIncidents;
  final int activeIncidents;
  final int firsProcessed;
  final int sosHandled;
  final int activeAuthorities;
}

