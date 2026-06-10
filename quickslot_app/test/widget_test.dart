import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/app.dart';

void main() {
  testWidgets('QuickSlot app renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to QuickSlot'), findsOneWidget);
  });
}
