import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacao/main.dart';

void main() {
  testWidgets('Home screen title smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Software de Avaliação da Atenção'), findsOneWidget);
  });
}
