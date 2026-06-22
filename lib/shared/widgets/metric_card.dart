import 'package:flutter/material.dart';

import '../../core/theme/safezone_colors.dart';
import 'glass_card.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = SafeZoneColors.cyan,
    this.caption,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withOpacity(.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 38),
          ),
          const SizedBox(height: 6),
          Text(label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall),
          if (caption != null) ...[
            const SizedBox(height: 8),
            Text(caption!,
                style: TextStyle(
                    color: Colors.white.withOpacity(.58), fontSize: 12)),
          ],
        ],
      ),
    );
  }
}
