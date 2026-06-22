import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/models/safezone_models.dart';
import '../../core/theme/safezone_colors.dart';
import '../../core/utils/enum_labels.dart';
import '../../data/providers.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/cyber_button.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/metric_card.dart';
import '../../shared/widgets/status_badge.dart';

class ResidentDashboardScreen extends ConsumerWidget {
  const ResidentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    return SafeZoneShell(
      title: 'Resident Dashboard',
      selectedIndex: 0,
      child: FutureBuilder(
        future: Future.wait(
            [repo.stats(), repo.myIncidents(), repo.notifications()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final stats = snapshot.data![0] as DashboardStats;
          final incidents = snapshot.data![1] as List<Incident>;
          final notifications = snapshot.data![2] as List<SafeZoneNotification>;
          return ListView(
            children: [
              Text('YOUR NEIGHBOURHOOD PROTECTED',
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
                      label: 'My Reports',
                      value: '${incidents.length}',
                      icon: Icons.report_rounded,
                      color: SafeZoneColors.cyan),
                  MetricCard(
                      label: 'Active Incidents',
                      value: '${stats.activeIncidents}',
                      icon: Icons.warning_rounded,
                      color: SafeZoneColors.danger),
                  const MetricCard(
                      label: 'SOS Status',
                      value: 'Online',
                      icon: Icons.sos_rounded,
                      color: SafeZoneColors.safe),
                  const MetricCard(
                      label: 'Safety Status',
                      value: 'Guarded',
                      icon: Icons.shield_rounded,
                      color: SafeZoneColors.warning),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickAction('Report Incident', Icons.add_alert_rounded,
                      '/resident/report', SafeZoneColors.danger),
                  _QuickAction('File FIR', Icons.description_rounded,
                      '/resident/fir', SafeZoneColors.cyan),
                  _QuickAction('SOS Emergency', Icons.sos_rounded,
                      '/resident/sos', SafeZoneColors.danger),
                  _QuickAction('My Incidents', Icons.list_alt_rounded,
                      '/resident/incidents', SafeZoneColors.safe),
                  _QuickAction('My FIRs', Icons.folder_copy_rounded,
                      '/resident/firs', SafeZoneColors.warning),
                  _QuickAction('Safety Map', Icons.map_rounded, '/resident/map',
                      SafeZoneColors.cyan),
                ],
              ),
              const SizedBox(height: 20),
              Text('Recent Alerts',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              for (final note in notifications.take(3)) _NotificationTile(note),
            ],
          );
        },
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.label, this.icon, this.path, this.color);

  final String label;
  final IconData icon;
  final String path;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: GlassCard(
        onTap: () => context.go(path),
        borderColor: color.withOpacity(.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 18),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class ReportIncidentScreen extends ConsumerStatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  ConsumerState<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends ConsumerState<ReportIncidentScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController(text: 'Sector 7');
  IncidentCategory _category = IncidentCategory.suspiciousActivity;
  SeverityLevel _severity = SeverityLevel.high;
  bool _anonymous = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: 'Report Incident',
      selectedIndex: 1,
      child: ListView(
        children: [
          Text('REAL-TIME INCIDENT REPORT',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: IncidentCategory.values
                      .map((item) => DropdownMenuItem(
                          value: item, child: Text(item.label)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  value: _severity,
                  decoration: const InputDecoration(labelText: 'Severity'),
                  items: SeverityLevel.values
                      .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.name[0].toUpperCase() +
                              item.name.substring(1))))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _severity = value ?? _severity),
                ),
                const SizedBox(height: 12),
                TextField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 12),
                TextField(
                    controller: _description,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        labelText: 'Detailed description')),
                const SizedBox(height: 12),
                TextField(
                    controller: _address,
                    decoration: const InputDecoration(
                        labelText: 'Address/location name',
                        prefixIcon: Icon(Icons.location_on_rounded))),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _anonymous,
                  title: const Text('Report anonymously'),
                  onChanged: (value) => setState(() => _anonymous = value),
                ),
                const SizedBox(height: 12),
                CyberButton(
                    label: 'Submit Incident',
                    icon: Icons.send_rounded,
                    expanded: true,
                    onPressed: _submit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty || _description.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title and description are required.')));
      return;
    }
    final incident = await ref.read(repositoryProvider).createIncident(
          title: _title.text.trim(),
          description: _description.text.trim(),
          category: _category,
          severity: _severity,
          latitude: 33.6844,
          longitude: 73.0479,
          address: _address.text.trim().isEmpty
              ? 'Current GPS location'
              : _address.text.trim(),
          anonymous: _anonymous,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${incident.number} submitted to command center.')));
    context.go('/resident/incidents');
  }
}

class FirWizardScreen extends ConsumerStatefulWidget {
  const FirWizardScreen({super.key});

  @override
  ConsumerState<FirWizardScreen> createState() => _FirWizardScreenState();
}

class _FirWizardScreenState extends ConsumerState<FirWizardScreen> {
  int _step = 0;
  bool _declared = false;
  final _title = TextEditingController();
  final _complainant = TextEditingController();
  final _description = TextEditingController();
  final _suspect = TextEditingController();
  final _witness = TextEditingController();
  final _loss = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _complainant.dispose();
    _description.dispose();
    _suspect.dispose();
    _witness.dispose();
    _loss.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: 'Digital FIR',
      selectedIndex: 0,
      child: ListView(
        children: [
          Text('DIGITAL FIR SYSTEM',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          GlassCard(
            child: Stepper(
              currentStep: _step,
              onStepContinue: _continue,
              onStepCancel: _step == 0 ? null : () => setState(() => _step--),
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    CyberButton(
                        label: _step == 4 ? 'Submit FIR' : 'Next',
                        onPressed: details.onStepContinue),
                    const SizedBox(width: 10),
                    if (_step > 0)
                      TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back')),
                  ],
                ),
              ),
              steps: [
                Step(
                    title: const Text('Complainant'),
                    content: TextField(
                        controller: _complainant,
                        decoration: const InputDecoration(
                            labelText: 'Complainant name')),
                    isActive: _step >= 0),
                Step(
                    title: const Text('Incident'),
                    content: Column(children: [
                      TextField(
                          controller: _title,
                          decoration:
                              const InputDecoration(labelText: 'FIR title')),
                      const SizedBox(height: 12),
                      TextField(
                          controller: _description,
                          minLines: 4,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              labelText: 'Incident details'))
                    ]),
                    isActive: _step >= 1),
                Step(
                    title: const Text('Suspect'),
                    content: TextField(
                        controller: _suspect,
                        decoration: const InputDecoration(
                            labelText: 'Accused/suspect details')),
                    isActive: _step >= 2),
                Step(
                    title: const Text('Evidence'),
                    content: Column(children: [
                      TextField(
                          controller: _witness,
                          decoration: const InputDecoration(
                              labelText: 'Witness details')),
                      const SizedBox(height: 12),
                      TextField(
                          controller: _loss,
                          decoration:
                              const InputDecoration(labelText: 'Loss/damage')),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file_rounded),
                          label: const Text('Attach evidence'))
                    ]),
                    isActive: _step >= 3),
                Step(
                    title: const Text('Review'),
                    content: CheckboxListTile(
                        value: _declared,
                        onChanged: (value) =>
                            setState(() => _declared = value ?? false),
                        title: const Text(
                            'I declare this FIR information is correct.')),
                    isActive: _step >= 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continue() async {
    if (_step < 4) {
      setState(() => _step++);
      return;
    }
    if (!_declared ||
        _title.text.trim().isEmpty ||
        _complainant.text.trim().isEmpty ||
        _description.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Complete required FIR fields and declaration.')));
      return;
    }
    final fir = await ref.read(repositoryProvider).createFir(
          title: _title.text.trim(),
          complainant: _complainant.text.trim(),
          description: _description.text.trim(),
          latitude: 33.6844,
          longitude: 73.0479,
          suspect: _suspect.text.trim(),
          witness: _witness.text.trim(),
          lossDamage: _loss.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${fir.number} submitted.')));
    context.go('/resident/firs');
  }
}

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen>
    with SingleTickerProviderStateMixin {
  EmergencyType _type = EmergencyType.police;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: 'SOS Emergency',
      selectedIndex: 2,
      child: Column(
        children: [
          Text('EMERGENCY ONLINE',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          DropdownButtonFormField(
            value: _type,
            decoration: const InputDecoration(labelText: 'Emergency type'),
            items: EmergencyType.values
                .map((type) =>
                    DropdownMenuItem(value: type, child: Text(type.label)))
                .toList(),
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SafeZoneColors.danger,
                boxShadow: [
                  BoxShadow(
                      color: SafeZoneColors.danger
                          .withOpacity(.25 + _pulse.value * .35),
                      blurRadius: 32 + _pulse.value * 42,
                      spreadRadius: 8 + _pulse.value * 16),
                ],
              ),
              child: TextButton(
                onPressed: _trigger,
                child: const Text('SOS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ),
          const Spacer(),
          const Text(
              'Current location will be attached. Manual map selection is available from the map screen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: SafeZoneColors.muted)),
        ],
      ),
    );
  }

  Future<void> _trigger() async {
    final sos = await ref
        .read(repositoryProvider)
        .createSos(_type, 33.6844, 73.0479, 'Current GPS location');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${sos.number} dispatched to authorities.')));
    context.go('/resident');
  }
}

class SafeMapScreen extends ConsumerWidget {
  const SafeMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    return SafeZoneShell(
      title: 'Safety Map',
      selectedIndex: 3,
      child: FutureBuilder<List<Incident>>(
        future: repo.incidents(),
        builder: (context, snapshot) {
          final incidents = snapshot.data ?? [];
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: FlutterMap(
              options: const MapOptions(
                  initialCenter: LatLng(33.6844, 73.0479), initialZoom: 13),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.safezone.mobile',
                ),
                MarkerLayer(
                  markers: [
                    for (final incident in incidents)
                      Marker(
                        point: incident.location,
                        width: 46,
                        height: 46,
                        child: IconButton(
                          icon: Icon(Icons.location_on_rounded,
                              color: incident.severity == SeverityLevel.critical
                                  ? SafeZoneColors.danger
                                  : SafeZoneColors.cyan,
                              size: 38),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(incident.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 8),
                                  Text(incident.address),
                                  const SizedBox(height: 12),
                                  StatusBadge.severity(
                                      severity: incident.severity),
                                ],
                              ),
                            ),
                          ),
                        ),
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

class MyIncidentsScreen extends ConsumerWidget {
  const MyIncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ListShell<Incident>(
      title: 'My Incidents',
      future: ref.watch(repositoryProvider).myIncidents(),
      empty: const EmptyState(
          title: 'No incidents yet',
          message: 'Reports you submit will appear here.'),
      itemBuilder: (incident) => _IncidentTile(incident),
    );
  }
}

class MyFirsScreen extends ConsumerWidget {
  const MyFirsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ListShell<FirReport>(
      title: 'My FIRs',
      future: ref.watch(repositoryProvider).myFirs(),
      empty: const EmptyState(
          title: 'No FIRs yet',
          message: 'Digital FIR submissions will appear here.'),
      itemBuilder: (fir) => GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(fir.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(fir.number, style: const TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 12),
          StatusBadge.fir(status: fir.status),
        ]),
      ),
    );
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeZoneShell(
      title: 'Notifications',
      selectedIndex: 0,
      child: FutureBuilder<List<SafeZoneNotification>>(
        future: ref.watch(repositoryProvider).notifications(),
        builder: (context, snapshot) {
          final notes = snapshot.data ?? [];
          return ListView(
            children: [
              Text('NOTIFICATION CENTER',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              for (final note in notes)
                _NotificationTile(note,
                    onTap: () => ref
                        .read(repositoryProvider)
                        .markNotificationRead(note.id)),
            ],
          );
        },
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(repositoryProvider).currentUser;
    return SafeZoneShell(
      title: 'Profile',
      selectedIndex: 4,
      child: ListView(
        children: [
          Text('PROFILE SETTINGS',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                    radius: 34,
                    backgroundColor: SafeZoneColors.safe,
                    child: Icon(Icons.person_rounded, color: Colors.black)),
                const SizedBox(height: 16),
                Text(user?.displayName ?? 'SafeZone User',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(user?.email ?? '',
                    style: const TextStyle(color: SafeZoneColors.muted)),
                const SizedBox(height: 16),
                const SwitchListTile(
                    value: true,
                    onChanged: null,
                    title: Text('Push/local alerts enabled')),
                const SwitchListTile(
                    value: true,
                    onChanged: null,
                    title: Text('Demo mode enabled')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListShell<T> extends StatelessWidget {
  const _ListShell(
      {required this.title,
      required this.future,
      required this.itemBuilder,
      required this.empty});

  final String title;
  final Future<List<T>> future;
  final Widget Function(T item) itemBuilder;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: title,
      selectedIndex: 0,
      child: FutureBuilder<List<T>>(
        future: future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          return ListView(
            children: [
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              if (items.isEmpty)
                empty
              else
                for (final item in items)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: itemBuilder(item)),
            ],
          );
        },
      ),
    );
  }
}

class _IncidentTile extends StatelessWidget {
  const _IncidentTile(this.incident);

  final Incident incident;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: incident.severity == SeverityLevel.critical
          ? SafeZoneColors.danger.withOpacity(.4)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(incident.title,
                      style: Theme.of(context).textTheme.titleLarge)),
              StatusBadge.incident(status: incident.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('${incident.number} - ${incident.address}',
              style: const TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            StatusBadge.severity(severity: incident.severity),
            Chip(label: Text(incident.category.label))
          ]),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.note, {this.onTap});

  final SafeZoneNotification note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        onTap: onTap,
        borderColor: note.read
            ? Colors.white.withOpacity(.08)
            : SafeZoneColors.safe.withOpacity(.24),
        child: Row(
          children: [
            Icon(
                note.read
                    ? Icons.notifications_none_rounded
                    : Icons.notifications_active_rounded,
                color: note.read ? SafeZoneColors.muted : SafeZoneColors.safe),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(note.body,
                      style: const TextStyle(color: SafeZoneColors.muted)),
                  const SizedBox(height: 4),
                  Text(DateFormat('MMM d, HH:mm').format(note.createdAt),
                      style: const TextStyle(
                          color: SafeZoneColors.dim, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
