import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eimunisasi/core/utils/dismiss_keyboard.dart';

void main() {
  group('dismissKeyboard', () {
    testWidgets('unfocuses when current focus does not have primary focus',
        (WidgetTester tester) async {
      final focusNode = FocusNode();
      final widget = MaterialApp(
        home: Scaffold(
          body: TextField(focusNode: focusNode),
        ),
      );

      await tester.pumpWidget(widget);
      focusNode.requestFocus();
      await tester.pump();

      expect(focusNode.hasFocus, true);

      dismissKeyboard(tester.element(find.byType(TextField)));

      await tester.pump();

      expect(focusNode.hasFocus, false);
    });
  });
}
