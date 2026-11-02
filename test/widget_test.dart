import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tulip_garden/main.dart';

void main() {
  testWidgets('App renders the game widget', (tester) async {
    await tester.pumpWidget(const TulipGardenApp());
    expect(find.byWidgetPredicate((w) => w is GameWidget), findsOneWidget);
  });
}
