import 'package:flutter/material.dart';

import '../../core/theme/safezone_colors.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key, this.label = 'Syncing command data'});

  final String label;

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _controller,
            child: const Icon(Icons.radar_rounded,
                color: SafeZoneColors.safe, size: 42),
          ),
          const SizedBox(height: 14),
          Text(widget.label,
              style: const TextStyle(color: SafeZoneColors.muted)),
        ],
      ),
    );
  }
}
