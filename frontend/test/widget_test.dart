import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('JobGenesisApp renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: JobGenesisApp(),
      ),
    );

    // Verify splash screen renders
    expect(find.text('JobGenesis'), findsOneWidget);
    expect(find.text('Your career. Evolved.'), findsOneWidget);
  });
}
