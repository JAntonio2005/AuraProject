import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aura_pet/main.dart';

void main() {
  testWidgets('smoke: app starts and shows home actions', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2560);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AuraApp());
    await tester.pump();

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);
  });

  testWidgets('smoke: auth routes are registered', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 2560);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AuraApp());
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final routes = app.routes ?? <String, WidgetBuilder>{};

    expect(routes.containsKey('/login'), isTrue);
    expect(routes.containsKey('/register'), isTrue);
  });
}
