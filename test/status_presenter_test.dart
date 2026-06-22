import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_mobile/core/models/safezone_enums.dart';
import 'package:safezone_mobile/core/utils/status_presenter.dart';

void main() {
  test('incident in-progress status renders as friendly text', () {
    final presentation = StatusPresenter.incident(IncidentStatus.inProgress);

    expect(presentation.label, 'In Progress');
    expect(presentation.label, isNot('InProgress'));
  });

  test('FIR under-review status renders as friendly text', () {
    final presentation = StatusPresenter.fir(FirStatus.underReview);

    expect(presentation.label, 'Under Review');
    expect(presentation.label, isNot('UnderReview'));
  });

  test('unknown presentation renders safe fallback text', () {
    final presentation = StatusPresenter.unknown();

    expect(presentation.label, 'Unknown');
    expect(presentation.tone, StatusTone.muted);
  });
}
