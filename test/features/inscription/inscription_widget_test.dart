import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider .dart';
import 'package:three_alfa_mobile_app/features/inscription/view/inscription_screen.dart';
import 'package:three_alfa_mobile_app/features/inscription/widgets/inscription_card.dart';
import 'package:three_alfa_mobile_app/features/inscription/widgets/decision_card.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:sizer/sizer.dart';

class MockInscriptionProvider extends Mock implements InscriptionProvider {}
class MockAuthProvider extends Mock implements AuthProvider {}
class MockUser extends Mock implements User {}

void main() {
  late MockInscriptionProvider mockInscriptionProvider;
  late MockAuthProvider mockAuthProvider;
  late MockUser mockUser;

  setUp(() {
    mockInscriptionProvider = MockInscriptionProvider();
    mockAuthProvider = MockAuthProvider();
    mockUser = MockUser();

    when(() => mockUser.photoURL).thenReturn(null);
    when(() => mockAuthProvider.user).thenReturn(mockUser);

    when(() => mockInscriptionProvider.isLoading).thenReturn(false);
    when(() => mockInscriptionProvider.isSubmitting).thenReturn(false);
    when(() => mockInscriptionProvider.errorMessage).thenReturn(null);
    when(() => mockInscriptionProvider.successMessage).thenReturn(null);
    when(() => mockInscriptionProvider.myInscriptions).thenReturn([]);
    when(() => mockInscriptionProvider.decisionsToRead).thenReturn([]);
    when(() => mockInscriptionProvider.historyInscriptions).thenReturn([]);
    when(() => mockInscriptionProvider.loadMyInscriptions()).thenAnswer((_) async {});
  });

  Widget createTestWidget() {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<InscriptionProvider>.value(value: mockInscriptionProvider),
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ],
          child: const MaterialApp(
            home: InscriptionScreen(),
          ),
        );
      }
    );
  }

  group('InscriptionScreen Widget Tests', () {
    testWidgets('should display empty message when no inscriptions', (WidgetTester tester) async {
      when(() => mockInscriptionProvider.myInscriptions).thenReturn([]);
      when(() => mockInscriptionProvider.isLoading).thenReturn(false);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Vous n\'avez encore aucune demande d\'inscription.'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading and no inscriptions', (WidgetTester tester) async {
      when(() => mockInscriptionProvider.myInscriptions).thenReturn([]);
      when(() => mockInscriptionProvider.isLoading).thenReturn(true);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display history inscriptions and decision inscriptions', (WidgetTester tester) async {
      final mockPending = InscriptionModel(
        id: 'i1',
        userId: 'u1',
        formationId: 'f1',
        formationTitle: 'History Formation',
        formationImageUrl: 'img',
        formationCategoryName: 'cat',
        status: InscriptionStatus.pending,
        decisionRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockDecision = InscriptionModel(
        id: 'i2',
        userId: 'u1',
        formationId: 'f2',
        formationTitle: 'Decision Formation',
        formationImageUrl: 'img',
        formationCategoryName: 'cat',
        status: InscriptionStatus.confirmed,
        decisionRead: false, // will appear in decisionsToRead
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockInscriptionProvider.myInscriptions).thenReturn([mockPending, mockDecision]);
      when(() => mockInscriptionProvider.historyInscriptions).thenReturn([mockPending]);
      when(() => mockInscriptionProvider.decisionsToRead).thenReturn([mockDecision]);
      
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InscriptionCard), findsOneWidget); // For history
      expect(find.byType(DecisionCard), findsOneWidget); // For decisions to read
      expect(find.text('History Formation'), findsOneWidget);
      expect(find.text('Decision Formation'), findsOneWidget);
    });
  });
}
