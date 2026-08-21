import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';
import 'package:three_alfa_mobile_app/features/profile/view/profile_screen.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/profile_header.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/profile_info_card.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:sizer/sizer.dart';

class MockProfileProvider extends Mock implements ProfileProvider {}
class MockAuthProvider extends Mock implements AuthProvider {}
class MockUser extends Mock implements User {}

void main() {
  late MockProfileProvider mockProfileProvider;
  late MockAuthProvider mockAuthProvider;
  late MockUser mockUser;

  setUp(() {
    mockProfileProvider = MockProfileProvider();
    mockAuthProvider = MockAuthProvider();
    mockUser = MockUser();

    when(() => mockUser.photoURL).thenReturn(null);
    when(() => mockAuthProvider.user).thenReturn(mockUser);

    when(() => mockProfileProvider.isLoading).thenReturn(false);
    when(() => mockProfileProvider.isSaving).thenReturn(false);
    when(() => mockProfileProvider.isUploadingPhoto).thenReturn(false);
    when(() => mockProfileProvider.errorMessage).thenReturn(null);
    when(() => mockProfileProvider.successMessage).thenReturn(null);
    when(() => mockProfileProvider.profile).thenReturn(null);
    when(() => mockProfileProvider.loadProfile()).thenAnswer((_) async {});
  });

  Widget createTestWidget() {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProfileProvider>.value(value: mockProfileProvider),
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        );
      }
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('should display loading indicator when loading and profile is null', (WidgetTester tester) async {
      when(() => mockProfileProvider.isLoading).thenReturn(true);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error and retry button when profile is null and error occurs', (WidgetTester tester) async {
      when(() => mockProfileProvider.errorMessage).thenReturn('Erreur de chargement');
      
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement'), findsOneWidget);
      expect(find.byType(SharedButton), findsOneWidget); // Retry button

      // Tap retry
      await tester.tap(find.byType(SharedButton));
      await tester.pump();
      
      // Called once in initState, once on button tap
      verify(() => mockProfileProvider.loadProfile()).called(2);
    });

    testWidgets('should display profile details when profile is loaded', (WidgetTester tester) async {
      final mockProfile = ProfileModel(
        uid: 'user123',
        nom: 'Doe',
        prenom: 'John',
        telephone: '12345678',
        dateNaissance: '01/01/2000',
        email: 'john.doe@gmail.com',
      );
      when(() => mockProfileProvider.profile).thenReturn(mockProfile);
      
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.byType(ProfileInfoCard), findsOneWidget);
      expect(find.text('modifier mes informations'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget); // Usually shown in header/info
    });
  });
}
