import 'package:flutter/material.dart';

import '../../core/theme/safezone_colors.dart';

enum CyberButtonTone { primary, emergency, ghost }

class CyberButton extends StatelessWidget {
  const CyberButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = CyberButtonTone.primary,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CyberButtonTone tone;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      CyberButtonTone.primary => SafeZoneColors.safe,
      CyberButtonTone.emergency => SafeZoneColors.danger,
      CyberButtonTone.ghost => Colors.white,
    };
    final background = tone == CyberButtonTone.ghost ? Colors.transparent : color;
    final foreground = tone == CyberButtonTone.ghost ? Colors.white : Colors.black;
    final child = FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 18),
      label: Text(label.toUpperCase()),
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        side: tone == CyberButtonTone.ghost ? BorderSide(color: Colors.white.withOpacity(.24)) : null,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        shadowColor: color.withOpacity(.5),
        elevation: tone == CyberButtonTone.ghost ? 0 : 10,
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}

