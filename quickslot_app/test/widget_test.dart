import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/app.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';

void main() {
  setUp(() {
    AppDependencies.userSession.clear();
  });

  testWidgets('User selection screen renders available users',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    await tester.pumpAndSettle();

    expect(find.text('Select User'), findsOneWidget);
    expect(find.text('Ashu'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Continue navigates away from user selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ashu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Select User'), findsNothing);
    expect(AppDependencies.userSession.selectedUser?.id, 1);
  });
}
