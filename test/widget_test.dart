import 'package:flutter_test/flutter_test.dart';
import 'package:tender_trust/main.dart';

void main() {
  testWidgets('TenderTrust app renders landing page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TenderTrustApp());

    // Verify the landing page loads with the app title
    expect(find.text('TenderTrust'), findsWidgets);
  });
}
