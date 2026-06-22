import 'package:flutter/material.dart';

import '../models/safezone_enums.dart';
import '../theme/safezone_colors.dart';

class StatusPresentation {
  const StatusPresentation({
    required this.label,
    required this.tone,
    required this.color,
    required this.icon,
  });

  final String label;
  final StatusTone tone;
  final Color color;
  final IconData icon;
}

class StatusPresenter {
  const StatusPresenter._();

  static StatusPresentation incident(IncidentStatus status) {
    return switch (status) {
      IncidentStatus.pending => const StatusPresentation(
          label: 'Pending',
          tone: StatusTone.warning,
          color: SafeZoneColors.warning,
          icon: Icons.schedule_rounded,
        ),
      IncidentStatus.assigned => const StatusPresentation(
          label: 'Assigned',
          tone: StatusTone.safe,
          color: SafeZoneColors.safe,
          icon: Icons.verified_user_rounded,
        ),
      IncidentStatus.inProgress => const StatusPresentation(
          label: 'In Progress',
          tone: StatusTone.command,
          color: SafeZoneColors.cyan,
          icon: Icons.radio_button_checked_rounded,
        ),
      IncidentStatus.resolved => const StatusPresentation(
          label: 'Resolved',
          tone: StatusTone.info,
          color: SafeZoneColors.cyan,
          icon: Icons.done_all_rounded,
        ),
      IncidentStatus.closed => const StatusPresentation(
          label: 'Closed',
          tone: StatusTone.muted,
          color: SafeZoneColors.muted,
          icon: Icons.lock_rounded,
        ),
    };
  }

  static StatusPresentation fir(FirStatus status) {
    return switch (status) {
      FirStatus.submitted => const StatusPresentation(
          label: 'Submitted',
          tone: StatusTone.info,
          color: SafeZoneColors.cyan,
          icon: Icons.file_present_rounded,
        ),
      FirStatus.underReview => const StatusPresentation(
          label: 'Under Review',
          tone: StatusTone.warning,
          color: SafeZoneColors.warning,
          icon: Icons.manage_search_rounded,
        ),
      FirStatus.accepted => const StatusPresentation(
          label: 'Accepted',
          tone: StatusTone.safe,
          color: SafeZoneColors.safe,
          icon: Icons.check_circle_rounded,
        ),
      FirStatus.rejected => const StatusPresentation(
          label: 'Rejected',
          tone: StatusTone.danger,
          color: SafeZoneColors.danger,
          icon: Icons.cancel_rounded,
        ),
      FirStatus.investigating => const StatusPresentation(
          label: 'Investigating',
          tone: StatusTone.command,
          color: SafeZoneColors.cyan,
          icon: Icons.radar_rounded,
        ),
      FirStatus.closed => const StatusPresentation(
          label: 'Closed',
          tone: StatusTone.muted,
          color: SafeZoneColors.muted,
          icon: Icons.lock_rounded,
        ),
    };
  }

  static StatusPresentation severity(SeverityLevel severity) {
    return switch (severity) {
      SeverityLevel.low => const StatusPresentation(
          label: 'Low',
          tone: StatusTone.safe,
          color: SafeZoneColors.safe,
          icon: Icons.shield_rounded,
        ),
      SeverityLevel.medium => const StatusPresentation(
          label: 'Medium',
          tone: StatusTone.warning,
          color: SafeZoneColors.warning,
          icon: Icons.warning_amber_rounded,
        ),
      SeverityLevel.high => const StatusPresentation(
          label: 'High',
          tone: StatusTone.danger,
          color: SafeZoneColors.orange,
          icon: Icons.priority_high_rounded,
        ),
      SeverityLevel.critical => const StatusPresentation(
          label: 'Critical',
          tone: StatusTone.danger,
          color: SafeZoneColors.danger,
          icon: Icons.crisis_alert_rounded,
        ),
    };
  }

  static StatusPresentation unknown() => const StatusPresentation(
        label: 'Unknown',
        tone: StatusTone.muted,
        color: SafeZoneColors.muted,
        icon: Icons.help_outline_rounded,
      );
}

