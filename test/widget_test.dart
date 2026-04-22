import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/app.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const GymTrackerApp());
    expect(find.text('Gym Tracker'), findsOneWidget);
  });
}
