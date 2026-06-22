import '../models/safezone_enums.dart';

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.resident => 'Resident',
        UserRole.authority => 'Authority',
        UserRole.admin => 'Admin',
        UserRole.superAdmin => 'SuperAdmin',
      };
}

extension IncidentCategoryLabel on IncidentCategory {
  String get label => switch (this) {
        IncidentCategory.theft => 'Theft',
        IncidentCategory.accident => 'Accident',
        IncidentCategory.vandalism => 'Vandalism',
        IncidentCategory.fire => 'Fire',
        IncidentCategory.suspiciousActivity => 'Suspicious Activity',
        IncidentCategory.other => 'Other',
      };
}

extension EmergencyTypeLabel on EmergencyType {
  String get label => switch (this) {
        EmergencyType.police => 'Police',
        EmergencyType.ambulance => 'Ambulance',
        EmergencyType.fireBrigade => 'Fire Brigade',
        EmergencyType.trafficPolice => 'Traffic Police',
      };
}

extension AlertTypeLabel on AlertType {
  String get label => switch (this) {
        AlertType.emergency => 'Emergency',
        AlertType.warning => 'Warning',
        AlertType.info => 'Info',
        AlertType.weatherAlert => 'Weather Alert',
        AlertType.curfewNotice => 'Curfew Notice',
      };
}

