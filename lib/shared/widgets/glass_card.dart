import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/safezone_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: padding,
          decoration: BoxDecoration(
            color: SafeZoneColors.panel.withOpacity(.72),
            borderRadius: BorderRadius.circular(radius),
            border:
                Border.all(color: borderColor ?? Colors.white.withOpacity(.12)),
            boxShadow: [
              BoxShadow(
                color: (borderColor ?? Colors.black).withOpacity(.14),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
    if (onTap == null) return card;
    return InkWell(
        borderRadius: BorderRadius.circular(radius), onTap: onTap, child: card);
  }
}
