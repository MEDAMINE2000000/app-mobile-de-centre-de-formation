import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:three_alfa_mobile_app/features/auth/register/register_screen.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:sizer/sizer.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    // Default mock values
    when(() => mockAuthProvider.isLoading).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn(null);
  });

  Widget createTestWidget() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const RegisterScreen(),
          ),
        ),
        GoRoute(
          path: '/verify-email',
          builder: (context, state) => const Scaffold(body: Text('Verify Email')),
        ),
      ],
    );

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          routerConfig: router,
        );
      }
    );
  }

  group('RegisterScreen Widget Tests', () {
    testWidgets('should display all register fields and button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(7));
      expect(find.byType(SharedButton), findsOneWidget); 
    });

    testWidgets('should show validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the register button without filling fields
      await tester.ensureVisible(find.byType(SharedButton));
      await tester.tap(find.byType(SharedButton));
      await tester.pump();

      // Should find validator error messages
      expect(find.text('Nom requis'), findsOneWidget);
      expect(find.text('Prénom requis'), findsOneWidget);
      expect(find.text('Téléphone requis'), findsOneWidget);
      expect(find.text('Date de naissance requise'), findsOneWidget);
      expect(find.text('Identifiant requis'), findsOneWidget);
      expect(find.text('Mot de passe requis'), findsOneWidget);
      expect(find.text('Confirmation requise'), findsOneWidget);
      
      // Verify register was NOT called
      verifyNever(() => mockAuthProvider.register(
        nom: any(named: 'nom'),
        prenom: any(named: 'prenom'),
        telephone: any(named: 'telephone'),
        dateNaissance: any(named: 'dateNaissance'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    testWidgets('should call register when fields are filled correctly', (WidgetTester tester) async {
      when(() => mockAuthProvider.register(
            nom: any(named: 'nom'),
            prenom: any(named: 'prenom'),
            telephone: any(named: 'telephone'),
            dateNaissance: any(named: 'dateNaissance'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill fields
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Doe');
      await tester.enterText(fields.at(1), 'John');
      await tester.enterText(fields.at(2), '12345678');
      
      await tester.enterText(fields.at(3), '01/01/2000');

      await tester.enterText(fields.at(4), 'test@gmail.com');
      await tester.enterText(fields.at(5), 'password123');
      await tester.enterText(fields.at(6), 'password123');

      // Scroll to button and tap
      await tester.ensureVisible(find.byType(SharedButton));
      await tester.tap(find.byType(SharedButton));
      await tester.pump(); 

      // Verify register called
      verify(() => mockAuthProvider.register(
        nom: 'Doe',
        prenom: 'John',
        telephone: '12345678',
        dateNaissance: any(named: 'dateNaissance'), // depends on current date, so match any
        email: 'test@gmail.com',
        password: 'password123',
      )).called(1);
    });

    testWidgets('should show error snackbar when register fails', (WidgetTester tester) async {
      when(() => mockAuthProvider.register(
            nom: any(named: 'nom'),
            prenom: any(named: 'prenom'),
            telephone: any(named: 'telephone'),
            dateNaissance: any(named: 'dateNaissance'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => false);
      when(() => mockAuthProvider.errorMessage).thenReturn('Erreur serveur');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill fields
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Doe');
      await tester.enterText(fields.at(1), 'John');
      await tester.enterText(fields.at(2), '12345678');
      
      await tester.enterText(fields.at(3), '01/01/2000');

      await tester.enterText(fields.at(4), 'test@gmail.com');
      await tester.enterText(fields.at(5), 'password123');
      await tester.enterText(fields.at(6), 'password123');

      // Tap register
      await tester.ensureVisible(find.byType(SharedButton));
      await tester.tap(find.byType(SharedButton));
      await tester.pump();
      await tester.pump();

      // Verify snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Erreur serveur'), findsOneWidget);
    });
  });
}
