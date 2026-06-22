import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/models/safezone_models.dart';
import '../../core/theme/safezone_colors.dart';
import '../../core/utils/enum_labels.dart';
import '../../core/utils/status_presenter.dart';
import '../../data/providers.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/cyber_button.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/metric_card.dart';
import '../../shared/widgets/status_badge.dart';

class AuthorityDashboardScreen extends ConsumerWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    return SafeZoneShell(
      title: 'Command Center',
      selectedIndex: 0,
      role: UserRole.authority,
      child: FutureBuilder(
        future: Future.wait([repo.stats(), repo.incidents(), repo.alerts()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final stats = snapshot.data![0] as DashboardStats;
          final incidents = snapshot.data![1] as List<Incident>;
          final alerts = snapshot.data![2] as List<SafeZoneAlert>;
          return ListView(
            children: [
              Text('AUTHORITY COMMAND CENTER',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.02,
                children: [
                  MetricCard(
                      label: 'Total Incidents',
                      value: '${stats.totalIncidents}',
                      icon: Icons.warning_rounded,
                      color: SafeZoneColors.danger),
                  MetricCard(
                      label: 'Active Incidents',
                      value: '${stats.activeIncidents}',
                      icon: Icons.radar_rounded,
                      color: SafeZoneColors.cyan),
                  MetricCard(
                      label: 'Pending FIRs',
                      value: '${stats.firsProcessed + 1}',
                      icon: Icons.description_rounded,
                      color: SafeZoneColors.warning),
                  MetricCard(
                      label: 'SOS Handled',
                      value: '${stats.sosHandled}',
                      icon: Icons.sos_rounded,
                      color: SafeZoneColors.safe),
                ],
              ),
              const SizedBox(height: 18),
              Text('Recent Incidents',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              for (final incident in incidents.take(4))
                _AuthorityIncidentTile(incident),
              const SizedBox(height: 18),
              Text('Active Alerts',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              for (final alert in alerts) _AlertTile(alert),
            ],
          );
        },
      ),
    );
  }
}

class FieldReportsScreen extends ConsumerWidget {
  const FieldReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'Field Reports',
      selectedIndex: 1,
      role: UserRole.authority,
      child: FutureBuilder<List<Incident>>(
        future: ref.watch(repositoryProvider).incidents(),
        builder: (context, snapshot) {
          final incidents = snapshot.data ?? [];
          return ListView(
            children: [
              Text('FIELD REPORTS',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              const TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      labelText: 'Search incident number or title')),
              const SizedBox(height: 16),
              for (final incident in incidents)
                _AuthorityIncidentTile(incident, actionable: true),
            ],
          );
        },
      ),
    );
  }
}

class DispatchMapScreen extends ConsumerWidget {
  const DispatchMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'Dispatch Map',
      selectedIndex: 1,
      role: UserRole.authority,
      child: FutureBuilder<List<Incident>>(
        future: ref.watch(repositoryProvider).incidents(),
        builder: (context, snapshot) {
          final incidents = snapshot.data ?? [];
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(33.6844, 73.0479), initialZoom: 13),
              children: [
                TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.safezone.mobile'),
                MarkerLayer(
                  markers: [
                    for (final incident in incidents)
                      Marker(
                        point: incident.location,
                        width: 48,
                        height: 48,
                        child: Icon(Icons.emergency_share_rounded,
                            color: StatusPresenter.severity(incident.severity)
                                .color,
                            size: 38),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class KanbanScreen extends ConsumerStatefulWidget {
  const KanbanScreen({super.key});

  @override
  ConsumerState<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends ConsumerState<KanbanScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final wide = MediaQuery.sizeOf(context).width > 880;
    return SafeZoneShell(
      title: 'Kanban Board',
      selectedIndex: 2,
      role: UserRole.authority,
      child: FutureBuilder<List<Incident>>(
        future: repo.incidents(),
        builder: (context, snapshot) {
          final incidents = snapshot.data ?? [];
          final board = IncidentStatus.values
              .map((status) => _KanbanColumnData(status,
                  incidents.where((item) => item.status == status).toList()))
              .toList();
          final content = wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (final column in board)
                    Expanded(child: _KanbanColumn(data: column, onMove: _move))
                ])
              : ListView(children: [
                  for (final column in board)
                    _KanbanColumn(data: column, onMove: _move)
                ]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DRAG RESPONSE WORKFLOW',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }

  Future<void> _move(Incident incident, IncidentStatus status) async {
    try {
      await ref.read(repositoryProvider).moveIncident(incident.id, status);
      setState(() {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${incident.number} moved to ${StatusPresenter.incident(status).label}.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', ''))));
    }
  }
}

class _KanbanColumnData {
  const _KanbanColumnData(this.status, this.incidents);

  final IncidentStatus status;
  final List<Incident> incidents;
}

class _KanbanColumn extends ConsumerWidget {
  const _KanbanColumn({required this.data, required this.onMove});

  final _KanbanColumnData data;
  final Future<void> Function(Incident incident, IncidentStatus status) onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presentation = StatusPresenter.incident(data.status);
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 12),
      child: DragTarget<Incident>(
        onWillAcceptWithDetails: (details) => ref
            .read(repositoryProvider)
            .canMoveIncident(details.data.status, data.status),
        onAcceptWithDetails: (details) => onMove(details.data, data.status),
        builder: (context, candidate, rejected) => GlassCard(
          radius: 18,
          borderColor: candidate.isEmpty
              ? presentation.color.withOpacity(.25)
              : SafeZoneColors.safe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(presentation.label,
                        style: const TextStyle(fontWeight: FontWeight.w900))),
                Text('${data.incidents.length}')
              ]),
              const SizedBox(height: 12),
              for (final incident in data.incidents)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Draggable<Incident>(
                    data: incident,
                    feedback: Material(
                        color: Colors.transparent,
                        child:
                            SizedBox(width: 260, child: _KanbanCard(incident))),
                    childWhenDragging:
                        Opacity(opacity: .35, child: _KanbanCard(incident)),
                    child: _KanbanCard(incident,
                        onTap: () => _showMoveSheet(context, ref, incident)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoveSheet(BuildContext context, WidgetRef ref, Incident incident) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Text('Move ${incident.number}',
                style: Theme.of(context).textTheme.titleLarge),
            for (final status in IncidentStatus.values)
              if (ref
                  .read(repositoryProvider)
                  .canMoveIncident(incident.status, status))
                ActionChip(
                    label: Text(StatusPresenter.incident(status).label),
                    onPressed: () => onMove(incident, status)
                        .then((_) => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard(this.incident, {this.onTap});

  final Incident incident;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      radius: 14,
      padding: const EdgeInsets.all(14),
      borderColor:
          StatusPresenter.severity(incident.severity).color.withOpacity(.35),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(incident.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(incident.number,
            style: const TextStyle(color: SafeZoneColors.muted, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(spacing: 6, children: [
          StatusBadge.severity(severity: incident.severity),
          Chip(label: Text(incident.category.label))
        ]),
      ]),
    );
  }
}

class FirManagementScreen extends ConsumerWidget {
  const FirManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'FIR Management',
      selectedIndex: 2,
      role: UserRole.authority,
      child: FutureBuilder<List<FirReport>>(
        future: ref.watch(repositoryProvider).firs(),
        builder: (context, snapshot) {
          final firs = snapshot.data ?? [];
          return ListView(
            children: [
              Text('FIR MANAGEMENT',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              for (final fir in firs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(fir.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge)),
                            StatusBadge.fir(status: fir.status)
                          ]),
                          const SizedBox(height: 8),
                          Text('${fir.number} - ${fir.complainant}',
                              style:
                                  const TextStyle(color: SafeZoneColors.muted)),
                          const SizedBox(height: 12),
                          Wrap(spacing: 8, children: [
                            ActionChip(
                                label: const Text('Accept'),
                                onPressed: () => _review(
                                    context, ref, fir, FirStatus.accepted)),
                            ActionChip(
                                label: const Text('Reject'),
                                onPressed: () => _review(
                                    context, ref, fir, FirStatus.rejected)),
                            ActionChip(
                                label: const Text('Close'),
                                onPressed: () => _review(
                                    context, ref, fir, FirStatus.closed)),
                          ]),
                        ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _review(BuildContext context, WidgetRef ref, FirReport fir,
      FirStatus status) async {
    await ref
        .read(repositoryProvider)
        .reviewFir(fir.id, status, 'Reviewed from SafeZone Mobile.');
    if (context.mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${fir.number} updated.')));
  }
}

class SosLogsScreen extends ConsumerWidget {
  const SosLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'SOS Logs',
      selectedIndex: 3,
      role: UserRole.authority,
      child: FutureBuilder<List<SosLog>>(
        future: ref.watch(repositoryProvider).sosLogs(),
        builder: (context, snapshot) {
          final logs = snapshot.data ?? [];
          return ListView(
            children: [
              Text('SOS LOGS',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              for (final log in logs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    borderColor: log.handled
                        ? SafeZoneColors.safe.withOpacity(.3)
                        : SafeZoneColors.danger.withOpacity(.35),
                    child: Row(children: [
                      Icon(Icons.sos_rounded,
                          color: log.handled
                              ? SafeZoneColors.safe
                              : SafeZoneColors.danger),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(
                              '${log.number} - ${log.type.label}\n${log.address}',
                              style: const TextStyle(height: 1.5))),
                      ActionChip(
                          label: Text(log.handled ? 'Handled' : 'Mark Handled'),
                          onPressed: log.handled
                              ? null
                              : () => ref
                                  .read(repositoryProvider)
                                  .markSosHandled(log.id)),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class BroadcastAlertScreen extends ConsumerStatefulWidget {
  const BroadcastAlertScreen({super.key});

  @override
  ConsumerState<BroadcastAlertScreen> createState() =>
      _BroadcastAlertScreenState();
}

class _BroadcastAlertScreenState extends ConsumerState<BroadcastAlertScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  AlertType _type = AlertType.warning;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: 'Broadcast Alert',
      selectedIndex: 0,
      role: UserRole.authority,
      child: ListView(
        children: [
          Text('BROADCAST ALERT',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(children: [
              DropdownButtonFormField(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Alert type'),
                  items: AlertType.values
                      .map((type) => DropdownMenuItem(
                          value: type, child: Text(type.label)))
                      .toList(),
                  onChanged: (value) => setState(() => _type = value ?? _type)),
              const SizedBox(height: 12),
              TextField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 12),
              TextField(
                  controller: _body,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Message')),
              const SizedBox(height: 16),
              CyberButton(
                  label: 'Broadcast',
                  icon: Icons.campaign_rounded,
                  expanded: true,
                  onPressed: _send),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    await ref
        .read(repositoryProvider)
        .broadcastAlert(_title.text.trim(), _body.text.trim(), _type);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Alert broadcast queued.')));
  }
}

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'Users',
      selectedIndex: 4,
      role: UserRole.authority,
      child: FutureBuilder<List<SafeZoneUser>>(
        future: ref.watch(repositoryProvider).users(),
        builder: (context, snapshot) {
          final users = snapshot.data ?? [];
          return ListView(
            children: [
              Text('USER MANAGEMENT',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              for (final user in users)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Row(children: [
                      CircleAvatar(
                          backgroundColor: user.active
                              ? SafeZoneColors.safe
                              : SafeZoneColors.dim,
                          child: const Icon(Icons.person_rounded,
                              color: Colors.black)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(
                              '${user.displayName}\n${user.email} - ${user.role.label}',
                              style: const TextStyle(height: 1.5))),
                      Switch(
                          value: user.active,
                          onChanged: (_) =>
                              ref.read(repositoryProvider).toggleUser(user.id)),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AuthorityIncidentTile extends ConsumerWidget {
  const _AuthorityIncidentTile(this.incident, {this.actionable = false});

  final Incident incident;
  final bool actionable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(incident.title,
                    style: Theme.of(context).textTheme.titleLarge)),
            StatusBadge.incident(status: incident.status)
          ]),
          const SizedBox(height: 8),
          Text(
              '${incident.number} - ${incident.address} - ${DateFormat('HH:mm').format(incident.reportedAt)}',
              style: const TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            StatusBadge.severity(severity: incident.severity),
            Chip(label: Text(incident.category.label)),
            if (actionable)
              ActionChip(
                label: const Text('Move Forward'),
                onPressed: () async {
                  final next = switch (incident.status) {
                    IncidentStatus.pending => IncidentStatus.assigned,
                    IncidentStatus.assigned => IncidentStatus.inProgress,
                    IncidentStatus.inProgress => IncidentStatus.resolved,
                    IncidentStatus.resolved => IncidentStatus.closed,
                    IncidentStatus.closed => IncidentStatus.closed,
                  };
                  if (next != incident.status)
                    await ref
                        .read(repositoryProvider)
                        .moveIncident(incident.id, next);
                },
              ),
          ]),
        ]),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile(this.alert);

  final SafeZoneAlert alert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderColor: alert.type == AlertType.emergency
            ? SafeZoneColors.danger.withOpacity(.4)
            : SafeZoneColors.cyan.withOpacity(.22),
        child: Row(children: [
          Icon(Icons.campaign_rounded,
              color: alert.type == AlertType.emergency
                  ? SafeZoneColors.danger
                  : SafeZoneColors.cyan),
          const SizedBox(width: 12),
          Expanded(
              child: Text('${alert.title}\n${alert.body}',
                  style: const TextStyle(height: 1.5))),
        ]),
      ),
    );
  }
}
