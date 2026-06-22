import 'package:flutter/material.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/utils/status_presenter.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.presentation});

  StatusBadge.incident({
    super.key,
    required IncidentStatus status,
  }) : presentation = StatusPresenter.incident(status);

  StatusBadge.fir({
    super.key,
    required FirStatus status,
  }) : presentation = StatusPresenter.fir(status);

  StatusBadge.severity({
    super.key,
    required SeverityLevel severity,
  }) : presentation = StatusPresenter.severity(severity);

  final StatusPresentation presentation;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: presentation.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: presentation.color.withOpacity(.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: presentation.color.withOpacity(.42)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(presentation.icon, size: 14, color: presentation.color),
            const SizedBox(width: 6),
            Text(
              presentation.label,
              style: TextStyle(
                color: presentation.color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
