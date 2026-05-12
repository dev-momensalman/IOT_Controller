import 'package:flutter_test/flutter_test.dart';
import 'package:rc_controller/main.dart';

void main() {
  testWidgets('RC Controller app smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const RcControllerApp());

    // Verify the controller screen renders (connection header is always present).
    expect(find.text('DISCONNECTED'), findsOneWidget);
  });
}
