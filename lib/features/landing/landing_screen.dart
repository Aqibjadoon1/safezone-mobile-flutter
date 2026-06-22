import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/safezone_colors.dart';
import '../../shared/widgets/cyber_button.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/metric_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroSection()),
          SliverToBoxAdapter(child: _WhiteSection()),
          SliverToBoxAdapter(child: _StatsSection()),
          SliverToBoxAdapter(child: _PreviewSection()),
          SliverToBoxAdapter(child: _FinalCta()),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 840;
    return Container(
      minHeight: MediaQuery.sizeOf(context).height,
      decoration: const BoxDecoration(gradient: SafeZoneColors.heroGradient),
      child: Stack(
        children: [
          const Positioned.fill(child: _GridBackdrop()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                children: [
                  _TopNav(),
                  const SizedBox(height: 54),
                  Flex(
                    direction: wide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: wide ? 6 : 0,
                        child: Column(
                          crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                          children: [
                            Text('LIVE EMERGENCY GRID', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: SafeZoneColors.cyan)),
                            const SizedBox(height: 18),
                            Text(
                              'DIGITAL\nSAFETY\nCOMMAND',
                              textAlign: wide ? TextAlign.left : TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    fontSize: wide ? 78 : 54,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Report incidents, file digital FIRs, trigger SOS alerts, and keep your neighbourhood protected through real-time authority response.',
                              textAlign: wide ? TextAlign.left : TextAlign.center,
                              style: TextStyle(color: Colors.white.withOpacity(.70), fontSize: 16, height: 1.6),
                            ),
                            const SizedBox(height: 28),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: wide ? WrapAlignment.start : WrapAlignment.center,
                              children: [
                                CyberButton(label: 'Join SafeZone', icon: Icons.shield_rounded, onPressed: () => context.go('/register')),
                                CyberButton(label: 'Sign In', icon: Icons.login_rounded, tone: CyberButtonTone.ghost, onPressed: () => context.go('/login')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 36, height: 36),
                      Expanded(
                        flex: wide ? 5 : 0,
                        child: SizedBox(
                          height: 430,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const _RadarVisual(),
                              Positioned(top: 22, left: 8, child: _AlertPill(title: 'Fire Alert', subtitle: 'Sector 4 - 2 min', color: SafeZoneColors.danger, icon: Icons.local_fire_department_rounded)),
                              Positioned(right: 0, top: 128, child: _AlertPill(title: 'Zone Secured', subtitle: 'Sector 7 - online', color: SafeZoneColors.safe, icon: Icons.verified_rounded)),
                              Positioned(left: 22, bottom: 56, child: _AlertPill(title: 'Suspicious Activity', subtitle: 'Sector 9 - active', color: SafeZoneColors.warning, icon: Icons.visibility_rounded)),
                              Positioned(right: 36, bottom: 4, child: _AlertPill(title: 'Emergency Online', subtitle: '24/7 response', color: SafeZoneColors.cyan, icon: Icons.sensors_rounded)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.shield_rounded, color: SafeZoneColors.safe),
        const SizedBox(width: 10),
        Text('SAFEZONE', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 1)),
        const Spacer(),
        TextButton(onPressed: () => context.go('/login'), child: const Text('SIGN IN')),
        const SizedBox(width: 8),
        CyberButton(label: 'Get Started', icon: Icons.arrow_forward_rounded, onPressed: () => context.go('/register')),
      ],
    );
  }
}

class _AlertPill extends StatelessWidget {
  const _AlertPill({required this.title, required this.subtitle, required this.color, required this.icon});

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 18,
      borderColor: color.withOpacity(.4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(subtitle, style: const TextStyle(color: SafeZoneColors.muted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadarVisual extends StatefulWidget {
  const _RadarVisual();

  @override
  State<_RadarVisual> createState() => _RadarVisualState();
}

class _RadarVisualState extends State<_RadarVisual> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _RadarPainter(_controller.value),
        child: const SizedBox(width: 360, height: 360, child: Center(child: Icon(Icons.shield_rounded, color: SafeZoneColors.safe, size: 74))),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(.12);
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, ringPaint);
    }
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), ringPaint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), ringPaint);
    final sweep = Paint()
      ..shader = SweepGradient(
        colors: [SafeZoneColors.safe.withOpacity(.0), SafeZoneColors.safe.withOpacity(.55)],
        stops: const [.72, 1],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Offset.zero & size);
    canvas.drawCircle(center, radius, sweep);
    final blipPaint = Paint()..color = SafeZoneColors.danger;
    canvas.drawCircle(Offset(size.width * .68, size.height * .34), 6 + math.sin(progress * math.pi * 2) * 2, blipPaint);
    canvas.drawCircle(Offset(size.width * .32, size.height * .64), 4, Paint()..color = SafeZoneColors.cyan);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.progress != progress;
}

class _GridBackdrop extends StatelessWidget {
  const _GridBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.035)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WhiteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SafeZoneColors.softWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(54)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SafeZone is a digital safety network for residents, responders, FIR workflows, and live authority command.', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black, fontSize: 42)),
              const SizedBox(height: 12),
              Text('PROTECTED RESPONSE GRID', style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.black.withOpacity(.06))),
              const SizedBox(height: 28),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: const [
                  _FeatureBlock(icon: Icons.report_rounded, title: 'Real-time Incident Reporting'),
                  _FeatureBlock(icon: Icons.description_rounded, title: 'Digital FIR System'),
                  _FeatureBlock(icon: Icons.phone_in_talk_rounded, title: 'AI Emergency Calling'),
                  _FeatureBlock(icon: Icons.security_rounded, title: 'Authority Command Center'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBlock extends StatelessWidget {
  const _FeatureBlock({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Icon(icon, color: SafeZoneColors.redDeep),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SafeZoneColors.voidBlack,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stats defining the safety grid', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 26),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 800 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.08,
                children: const [
                  MetricCard(label: 'Total Incidents', value: '500+', icon: Icons.warning_rounded, color: SafeZoneColors.danger),
                  MetricCard(label: 'Active Authorities', value: '48', icon: Icons.groups_rounded, color: SafeZoneColors.safe),
                  MetricCard(label: 'FIRs Processed', value: '220+', icon: Icons.description_rounded, color: SafeZoneColors.cyan),
                  MetricCard(label: 'SOS Calls Handled', value: '1.2k', icon: Icons.sos_rounded, color: SafeZoneColors.warning),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SafeZoneColors.voidBlack,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _PreviewCard(title: 'Resident Dashboard', icon: Icons.dashboard_rounded),
              _PreviewCard(title: 'Authority Dashboard', icon: Icons.security_rounded),
              _PreviewCard(title: 'Live Safety Map', icon: Icons.map_rounded),
              _PreviewCard(title: 'Glowing SOS Screen', icon: Icons.sos_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 180,
      child: GlassCard(
        borderColor: SafeZoneColors.cyan.withOpacity(.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: SafeZoneColors.cyan, size: 34),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: .72, color: SafeZoneColors.safe, backgroundColor: Colors.white.withOpacity(.08)),
          ],
        ),
      ),
    );
  }
}

class _FinalCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SafeZoneColors.voidBlack,
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 96),
      child: Column(
        children: [
          Text('Ready to protect your neighbourhood?', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              CyberButton(label: 'Create Account', icon: Icons.person_add_rounded, onPressed: () => context.go('/register')),
              CyberButton(label: 'Sign In', icon: Icons.login_rounded, tone: CyberButtonTone.ghost, onPressed: () => context.go('/login')),
            ],
          ),
        ],
      ),
    );
  }
}
