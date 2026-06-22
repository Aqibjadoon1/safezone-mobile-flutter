import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safezone_mobile/app/safezone_app.dart';

void main() {
  testWidgets('SafeZone app renders the cinematic landing screen',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SafeZoneApp()));
    await tester.pump();

    expect(find.text('DIGITAL\nSAFETY\nCOMMAND'), findsOneWidget);
    expect(find.text('JOIN SAFEZONE'), findsWidgets);
  });
}
