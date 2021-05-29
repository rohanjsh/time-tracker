import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  //first widget test
  testWidgets('hey', (WidgetTester tester) async {
    //material app ancestor
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CustomRaisedButton(
          child: Text('tap me'),
          onPressed: () => pressed = true,
        ),
      ),
    );
    //finders and matchers implementation
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget); //widgets can be found by finders
    expect(find.text('tap me'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
