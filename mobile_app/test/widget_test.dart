import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AayuTrackApp(),
      ),
    );

    expect(find.byType(AayuTrackApp), findsOneWidget);
  });
}
