import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot_app/app.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/core/di/app_dependencies.dart';

void main() {
  setUp(() {
    AppDependencies.userSession.clear();
  });

  testWidgets('User selection screen renders available users',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSlotApp());
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Who is using QuickSlot?'), findsOneWidget);
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

    expect(find.text('Who is using QuickSlot?'), findsNothing);
    expect(AppDependencies.userSession.selectedUser?.id, 1);
  });
}
