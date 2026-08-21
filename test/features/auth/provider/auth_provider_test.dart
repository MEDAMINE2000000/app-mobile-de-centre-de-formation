import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late AuthProvider authProvider;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();

    when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));
    when(() => mockUser.uid).thenReturn('user123');
    when(() => mockUser.email).thenReturn('test@test.com');
    when(() => mockUser.emailVerified).thenReturn(true);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    
    // We also need to mock currentUser for some methods
    when(() => mockAuth.currentUser).thenReturn(null);

    authProvider = AuthProvider(
      auth: mockAuth,
      firestore: fakeFirestore,
    );
  });

  group('AuthProvider Tests', () {
    test('initial state is correct', () {
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.isAdmin, isFalse);
      expect(authProvider.user, isNull);
      expect(authProvider.errorMessage, isNull);
    });

    test('login success updates state and returns true', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUserCredential);
      
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Need to mock reload if refreshUser is called
      when(() => mockUser.reload()).thenAnswer((_) async => {});

      final result = await authProvider.login('test@test.com', 'password123');

      expect(result, isTrue);
      expect(authProvider.user, mockUser);
      expect(authProvider.errorMessage, isNull);
    });

    test('login failure sets error message and returns false', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'wrong_password',
          )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await authProvider.login('test@test.com', 'wrong_password');

      expect(result, isFalse);
      expect(authProvider.errorMessage, 'Mot de passe incorrect.');
    });

    test('register success saves user to firestore', () async {
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUserCredential);
      
      // Mock sendEmailVerification
      when(() => mockUser.sendEmailVerification()).thenAnswer((_) async => {});

      final result = await authProvider.register(
        nom: 'Doe',
        prenom: 'John',
        telephone: '12345678',
        dateNaissance: '01/01/2000',
        email: 'test@test.com',
        password: 'password123',
      );

      expect(result, isTrue);
      
      // Check firestore
      final doc = await fakeFirestore.collection('users').doc('user123').get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['role'], 'user');
      expect(doc.data()?['nom'], 'Doe');
    });

    test('checkUserRole identifies admin correctly', () async {
      // Set current user
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      
      // Seed firestore with admin role
      await fakeFirestore.collection('users').doc('user123').set({'role': 'admin'});

      await authProvider.checkUserRole();

      expect(authProvider.isAdmin, isTrue);
    });

    test('checkUserRole identifies super_admin correctly by email', () async {
      final superAdminUser = MockUser();
      when(() => superAdminUser.uid).thenReturn('super123');
      when(() => superAdminUser.email).thenReturn('medhammi198@gmail.com');
      when(() => mockAuth.currentUser).thenReturn(superAdminUser);

      await authProvider.checkUserRole();

      expect(authProvider.isAdmin, isTrue);
    });
    
    test('logout clears user data', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async => {});
      
      // Simulate user is logged in
      authProvider.user = mockUser;
      authProvider.isAdmin = true;

      await authProvider.logout();

      expect(authProvider.user, isNull);
      expect(authProvider.isAdmin, isFalse);
    });
  });
}
