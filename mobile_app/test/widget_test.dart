import 'package:flutter_test/flutter_test.dart';
import 'package:aayutrack/main.dart';

void main() {
  testWidgets('app builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
