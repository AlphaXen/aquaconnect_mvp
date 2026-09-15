import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aquaconnect_mvp/app.dart';

void main() {
  testWidgets('App boots to the login screen when signed out', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AquaConnectApp()));
    await tester.pumpAndSettle();

    expect(find.text('AquaConnect'), findsWidgets);
    expect(find.text('로그인'), findsWidgets);
  });
}
