import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:three_alfa_mobile_app/features/auth/login/login_screen.dart';
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
    when(() => mockAuthProvider.isAdmin).thenReturn(false);
  });

  Widget createTestWidget() {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        );
      }
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should display email and password fields and login button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Allow animations to finish
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(SharedButton), findsOneWidget); 
    });

    testWidgets('should show validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the login button without filling fields
      await tester.tap(find.byType(SharedButton));
      await tester.pump();

      // Should find validator error messages
      expect(find.text('Identifiant requis'), findsOneWidget);
      expect(find.text('Mot de passe requis'), findsOneWidget);
      
      // Verify login was NOT called
      verifyNever(() => mockAuthProvider.login(any(), any()));
    });

    testWidgets('should call login when fields are filled', (WidgetTester tester) async {
      when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill fields
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@gmail.com');
      await tester.enterText(fields.at(1), 'password123');

      // Tap login
      await tester.tap(find.byType(SharedButton));
      await tester.pump(); // Start async operation

      // Verify login called
      verify(() => mockAuthProvider.login('test@gmail.com', 'password123')).called(1);
    });

    testWidgets('should show error snackbar when login fails', (WidgetTester tester) async {
      when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async => false);
      when(() => mockAuthProvider.errorMessage).thenReturn('Mot de passe incorrect.');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill fields
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@gmail.com');
      await tester.enterText(fields.at(1), 'wrongpass');

      // Tap login
      await tester.tap(find.byType(SharedButton));
      await tester.pump(); // Await future
      await tester.pump(); // Render snackbar

      // Verify snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Mot de passe incorrect.'), findsOneWidget);
    });
  });
}
