import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threee/threee.dart';

void main() {
  testWidgets('AnimatedLogo widget renders correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedLogo(
            size: 200,
            backgroundColor: Color(0xFF414141),
          ),
        ),
      ),
    );

    // Verify the widget is rendered
    expect(find.byType(AnimatedLogo), findsOneWidget);

    // Wait for animations to start and handle the delayed timer
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500)); // Wait for bounce2 delay

    // Verify the widget is still there after animation
    expect(find.byType(AnimatedLogo), findsOneWidget);
  });

  testWidgets('AnimatedLogo respects size parameter', (WidgetTester tester) async {
    const testSize = 150.0;
    
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedLogo(
            size: testSize,
            backgroundColor: Color(0xFF414141),
          ),
        ),
      ),
    );

    final logoWidget = tester.widget<AnimatedLogo>(find.byType(AnimatedLogo));
    expect(logoWidget.size, testSize);
    
    // Wait for delayed timer to complete
    await tester.pump(const Duration(milliseconds: 600));
  });
}
