import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/demo_safezone_repository.dart';
import 'repositories/safezone_repository.dart';

final safeZoneRepositoryProvider =
    ChangeNotifierProvider<DemoSafeZoneRepository>((ref) {
  return DemoSafeZoneRepository();
});

final repositoryProvider = Provider<SafeZoneRepository>((ref) {
  return ref.watch(safeZoneRepositoryProvider);
});
