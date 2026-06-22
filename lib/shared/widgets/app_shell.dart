import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/theme/safezone_colors.dart';
import '../../features/auth/auth_controller.dart';

class SafeZoneShell extends ConsumerWidget {
  const SafeZoneShell({
    super.key,
    required this.title,
    required this.child,
    required this.selectedIndex,
    this.role = UserRole.resident,
    this.actions = const [],
  });

  final String title;
  final Widget child;
  final int selectedIndex;
  final UserRole role;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = role == UserRole.resident
        ? _residentDestinations
        : _authorityDestinations;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Text('SAFEZONE COMMAND LINK',
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        actions: [
          ...actions,
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: SafeZoneColors.heroGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.clamp(0, destinations.length - 1),
        backgroundColor: SafeZoneColors.panel.withOpacity(.94),
        indicatorColor: SafeZoneColors.safe.withOpacity(.16),
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
                icon: Icon(destination.icon), label: destination.label),
        ],
        onDestinationSelected: (index) => context.go(destinations[index].path),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

const _residentDestinations = [
  _Destination('Home', Icons.dashboard_rounded, '/resident'),
  _Destination('Report', Icons.add_alert_rounded, '/resident/report'),
  _Destination('SOS', Icons.sos_rounded, '/resident/sos'),
  _Destination('Map', Icons.map_rounded, '/resident/map'),
  _Destination('Profile', Icons.person_rounded, '/resident/profile'),
];

const _authorityDestinations = [
  _Destination('Command', Icons.space_dashboard_rounded, '/authority'),
  _Destination('Reports', Icons.assignment_rounded, '/authority/reports'),
  _Destination('Board', Icons.view_kanban_rounded, '/authority/kanban'),
  _Destination('SOS', Icons.sensors_rounded, '/authority/sos'),
  _Destination('Users', Icons.group_rounded, '/authority/users'),
];
