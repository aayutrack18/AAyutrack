import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build the real application
    await tester.pumpWidget(
      const ProviderScope(
        child: AayuTrackApp(),
      ),
    );

    // Wait for initial frame
    await tester.pumpAndSettle();

    // Verify the app loaded
    expect(find.byType(AayuTrackApp), findsOneWidget);
  });
}