import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/common/widgets/app_bottom_nav.dart';
import 'package:nibangsh_consultancy/src/home/views/home_screen.dart';
import 'package:nibangsh_consultancy/src/main_navigation/views/main_navigation_screen.dart';

void main() {
  testWidgets('main navigation shell renders the bottom nav and home tab', (tester) async {
    Get.reset();
    await tester.pumpWidget(const GetMaterialApp(home: MainNavigationScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
