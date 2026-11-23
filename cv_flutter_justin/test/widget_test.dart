import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_justin/main.dart';

void main() {
  testWidgets('Vérification de l’écran de connexion', (WidgetTester tester) async {
    await tester.pumpWidget(const CvFlutterJustinApp());

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}