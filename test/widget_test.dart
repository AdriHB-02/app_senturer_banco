import 'package:flutter_test/flutter_test.dart';
import 'package:app_senturer_banco/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppSenturer());
    await tester.pump();

    expect(find.text('SENTURER'), findsWidgets);
  });
}
