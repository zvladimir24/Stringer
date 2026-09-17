import 'package:flutter_test/flutter_test.dart';
import 'package:stringer/app/app.dart';
import 'package:stringer/app/di/injection.dart';

void main() {
  setUpAll(configureDependencies);

  testWidgets('shows the no-file-selected state on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Nijedan fajl nije izabran'), findsOneWidget);
    expect(find.text('Izaberi Excel fajl'), findsOneWidget);
  });
}
