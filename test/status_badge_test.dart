import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_mobile/core/models/safezone_enums.dart';
import 'package:safezone_mobile/shared/widgets/status_badge.dart';

void main() {
  testWidgets('status badge renders friendly label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusBadge.incident(status: IncidentStatus.inProgress),
        ),
      ),
    );

    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('InProgress'), findsNothing);
  });
}
