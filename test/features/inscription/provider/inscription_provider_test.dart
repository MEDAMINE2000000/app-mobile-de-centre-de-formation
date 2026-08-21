import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider .dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late InscriptionProvider inscriptionProvider;
  late MockUser mockUser;

  setUp(() async {
    mockAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('user123');
    when(() => mockAuth.currentUser).thenReturn(mockUser);

    SharedPreferences.setMockInitialValues({});

    inscriptionProvider = InscriptionProvider(
      db: fakeFirestore,
      auth: mockAuth,
    );
  });

  group('InscriptionProvider Tests', () {
    test('initial state', () {
      expect(inscriptionProvider.isLoading, isFalse);
      expect(inscriptionProvider.isSubmitting, isFalse);
      expect(inscriptionProvider.myInscriptions, isEmpty);
      expect(inscriptionProvider.hiddenInscriptionIds, isEmpty);
    });

    test('submitInscription adds a new inscription if not already enrolled', () async {
      final result = await inscriptionProvider.submitInscription(
        formationId: 'f1',
        formationTitle: 'Flutter Mastery',
        formationImageUrl: 'img.png',
        formationCategoryName: 'Mobile',
      );

      expect(result, isTrue);
      expect(inscriptionProvider.successMessage, isNotNull);

      final query = await fakeFirestore.collection('inscriptions').get();
      expect(query.docs.length, 1);
      final doc = query.docs.first.data();
      expect(doc['formationId'], 'f1');
      expect(doc['status'], 'pending');
      expect(doc['userId'], 'user123');
    });

    test('submitInscription fails if already pending', () async {
      await fakeFirestore.collection('inscriptions').add({
        'userId': 'user123',
        'formationId': 'f1',
        'status': 'pending',
      });

      final result = await inscriptionProvider.submitInscription(
        formationId: 'f1',
        formationTitle: 'Flutter Mastery',
        formationImageUrl: 'img.png',
        formationCategoryName: 'Mobile',
      );

      expect(result, isFalse);
      expect(inscriptionProvider.errorMessage, 'Vous etes deja inscrit(e) a cette formation.');
    });

    test('loadMyInscriptions listens to firestore changes', () async {
      // Start listening
      await inscriptionProvider.loadMyInscriptions();
      expect(inscriptionProvider.isLoading, isTrue);

      // Add a document
      final docRef = await fakeFirestore.collection('inscriptions').add({
        'userId': 'user123',
        'formationId': 'f1',
        'formationTitle': 'T1',
        'formationImageUrl': 'img',
        'formationCategoryName': 'C1',
        'status': 'pending',
        'decisionRead': false,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      // Wait a moment for stream to trigger
      await Future.delayed(const Duration(milliseconds: 100));

      expect(inscriptionProvider.myInscriptions.length, 1);
      expect(inscriptionProvider.myInscriptions.first.formationId, 'f1');
      expect(inscriptionProvider.isLoading, isFalse);

      // Test getters
      expect(inscriptionProvider.pendingInscriptions.length, 1);
      expect(inscriptionProvider.confirmedInscriptions.length, 0);

      // Mark decision as read
      await inscriptionProvider.markDecisionAsRead(docRef.id);
      expect(inscriptionProvider.myInscriptions.first.decisionRead, isTrue);

      // Cancel inscription
      await inscriptionProvider.cancelInscription(docRef.id);
      final afterCancelQuery = await fakeFirestore.collection('inscriptions').doc(docRef.id).get();
      expect(afterCancelQuery.exists, isFalse);
    });
  });
}
