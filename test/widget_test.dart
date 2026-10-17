import 'package:flutter_test/flutter_test.dart';

import 'package:ict_learning_app/main.dart';
void main() {
  testWidgets('Home screen displays dashboard', (tester) async {
    await tester.pumpWidget(const ICTLearningApp());

    expect(find.text('Kavindi Perera'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
  });
}
