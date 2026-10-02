import 'package:flutter_test/flutter_test.dart';
import 'package:cmp/main.dart';

void main() {
  testWidgets('Component showcase screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present on the screen.
    expect(find.text('Catálogo de Componentes'), findsOneWidget);
    expect(find.text('Material 3 & AppTheme'), findsOneWidget);
  });
}
