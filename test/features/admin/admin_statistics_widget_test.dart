import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:three_alfa_mobile_app/features/admin/model/admin_stats_model.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/admin/view/admin_statistics_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class MockAdminProvider extends Mock implements AdminProvider {}

void main() {
  late MockAdminProvider mockAdminProvider;

  setUp(() {
    mockAdminProvider = MockAdminProvider();
    when(() => mockAdminProvider.stats).thenReturn(AdminStats(
      totalUsers: 10,
      totalAdmins: 2,
      totalNormalUsers: 8,
      totalFormations: 5,
      pendingInscriptions: 3,
      confirmedInscriptions: 6,
      rejectedInscriptions: 1,
      participantsPerFormation: {'Flutter': 4, 'React': 2},
      mostPopularFormation: 'Flutter',
    ));
  });

  Widget createTestWidget() {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ChangeNotifierProvider<AdminProvider>.value(
          value: mockAdminProvider,
          child: const MaterialApp(
            home: AdminStatisticsScreen(),
          ),
        );
      }
    );
  }

  group('AdminStatisticsScreen Widget Tests', () {
    testWidgets('should render charts and statistics correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Wait for animations (using pump rather than pumpAndSettle if there are infinite animations)
      // Actually flutter_animate might need pumpAndSettle or we just use it safely.
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      // Check title
      expect(find.text('Statistiques & Analyses'), findsOneWidget);

      // Check charts are present
      expect(find.byType(BarChart), findsOneWidget);
      
      // Scroll to reveal the rest
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      expect(find.byType(PieChart), findsOneWidget);

      // Check activity texts
      expect(find.text('Activité récente'), findsOneWidget);
      expect(find.text('Flutter'), findsWidgets);
      expect(find.text('6 demandes validées'), findsOneWidget);
      expect(find.text('1 demandes rejetées'), findsOneWidget);
    });
  });
}
