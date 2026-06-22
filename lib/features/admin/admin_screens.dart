import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/theme/safezone_colors.dart';
import '../../data/providers.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/metric_card.dart';

class AdminCommandCenterScreen extends ConsumerWidget {
  const AdminCommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'SuperAdmin',
      selectedIndex: 0,
      role: UserRole.superAdmin,
      child: FutureBuilder(
        future: Future.wait([
          ref.watch(repositoryProvider).stats(),
          ref.watch(repositoryProvider).users(),
          ref.watch(repositoryProvider).alerts(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final stats = snapshot.data![0] as dynamic;
          final users = snapshot.data![1] as List;
          final alerts = snapshot.data![2] as List;
          return ListView(
            children: [
              Text('SUPERADMIN COMMAND CENTER', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.02,
                children: [
                  MetricCard(label: 'Incidents', value: '${stats.totalIncidents}', icon: Icons.warning_rounded, color: SafeZoneColors.danger),
                  MetricCard(label: 'Authorities', value: '${stats.activeAuthorities}', icon: Icons.security_rounded, color: SafeZoneColors.safe),
                  MetricCard(label: 'Users', value: '${users.length}', icon: Icons.group_rounded, color: SafeZoneColors.cyan),
                  MetricCard(label: 'Alerts', value: '${alerts.length}', icon: Icons.campaign_rounded, color: SafeZoneColors.warning),
                ],
              ),
              const SizedBox(height: 18),
              const GlassCard(
                child: Text(
                  'System settings, integration health, audit logs, and role management are organized for the SafeZone backend contract. Demo mode keeps all controls local.',
                  style: TextStyle(color: SafeZoneColors.muted, height: 1.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

