// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylehub_mobile/core/config/app_config.dart';
import 'package:stylehub_mobile/core/config/app_flavor.dart';
import 'package:stylehub_mobile/core/config/providers.dart';
import 'package:stylehub_mobile/features/salon_selection/presentation/select_salon_screen.dart';

void main() {
  testWidgets('Select salon screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(const AppConfig(flavor: AppFlavor.dev)),
        ],
        child: const MaterialApp(home: SelectSalonScreen()),
      ),
    );

    expect(find.text('Selecione seu salão'), findsOneWidget);
    expect(find.text('Validar'), findsOneWidget);
  });
}
