enum UserRole { resident, authority, admin, superAdmin }

enum IncidentStatus { pending, assigned, inProgress, resolved, closed }

enum SeverityLevel { low, medium, high, critical }

enum IncidentCategory {
  theft,
  accident,
  vandalism,
  fire,
  suspiciousActivity,
  other,
}

enum FirStatus { submitted, underReview, accepted, rejected, investigating, closed }

enum EmergencyType { police, ambulance, fireBrigade, trafficPolice }

enum AlertType { emergency, warning, info, weatherAlert, curfewNotice }

enum StatusTone { safe, info, warning, danger, muted, command }

