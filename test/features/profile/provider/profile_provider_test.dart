import 'dart:io';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockReference extends Mock implements Reference {}
class MockTaskSnapshot extends Mock implements TaskSnapshot {}
class MockUploadTask extends Mock implements UploadTask {
  @override
  Future<S> then<S>(FutureOr<S> Function(TaskSnapshot)? onValue, {Function? onError}) async {
    return onValue!(MockTaskSnapshot());
  }
}

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseStorage mockStorage;
  late ProfileProvider profileProvider;
  late MockUser mockUser;
  late MockReference mockStorageRef;
  late MockReference mockUserStorageRef;
  late MockReference mockAvatarRef;

  setUpAll(() {
    registerFallbackValue(File('test.jpg'));
    registerFallbackValue(SettableMetadata());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('user123');
    when(() => mockUser.email).thenReturn('test@test.com');
    when(() => mockUser.displayName).thenReturn('Old Name');
    when(() => mockAuth.currentUser).thenReturn(mockUser);

    mockStorageRef = MockReference();
    mockUserStorageRef = MockReference();
    mockAvatarRef = MockReference();

    when(() => mockStorage.ref()).thenReturn(mockStorageRef);
    when(() => mockStorageRef.child('profile_pictures')).thenReturn(mockStorageRef);
    when(() => mockStorageRef.child('user123')).thenReturn(mockUserStorageRef);
    when(() => mockUserStorageRef.child('avatar.jpg')).thenReturn(mockAvatarRef);

    profileProvider = ProfileProvider(
      auth: mockAuth,
      db: fakeFirestore,
      storage: mockStorage,
    );
  });

  group('ProfileProvider Tests', () {
    test('initial state', () {
      expect(profileProvider.isLoading, isFalse);
      expect(profileProvider.isSaving, isFalse);
      expect(profileProvider.isUploadingPhoto, isFalse);
      expect(profileProvider.profile, isNull);
    });

    test('loadProfile fetches user data successfully', () async {
      await fakeFirestore.collection('users').doc('user123').set({
        'uid': 'user123',
        'nom': 'Doe',
        'prenom': 'John',
        'telephone': '12345678',
        'dateNaissance': '01/01/2000',
        'role': 'user',
        'photoUrl': 'http://image.com/img.jpg',
      });

      await profileProvider.loadProfile();

      expect(profileProvider.profile, isNotNull);
      expect(profileProvider.profile!.nom, 'Doe');
      expect(profileProvider.profile!.prenom, 'John');
      expect(profileProvider.errorMessage, isNull);
    });

    test('updateProfile updates firestore and local state', () async {
      // Setup initial profile
      await fakeFirestore.collection('users').doc('user123').set({
        'uid': 'user123',
        'nom': 'Old',
        'prenom': 'Name',
      });
      await profileProvider.loadProfile();

      when(() => mockUser.updateDisplayName('Jane Smith')).thenAnswer((_) async => {});
      when(() => mockUser.reload()).thenAnswer((_) async => {});

      final result = await profileProvider.updateProfile(
        nom: 'Smith',
        prenom: 'Jane',
        telephone: '87654321',
        dateNaissance: '02/02/2002',
      );

      expect(result, isTrue);
      expect(profileProvider.profile!.nom, 'Smith');
      expect(profileProvider.profile!.prenom, 'Jane');
      expect(profileProvider.profile!.telephone, '87654321');
      expect(profileProvider.successMessage, 'Profil mis à jour avec succès.');

      final doc = await fakeFirestore.collection('users').doc('user123').get();
      expect(doc.data()!['nom'], 'Smith');
      expect(doc.data()!['telephone'], '87654321');
    });

    test('uploadProfilePicture updates storage, auth and firestore', () async {
      // Setup initial profile
      await fakeFirestore.collection('users').doc('user123').set({
        'uid': 'user123',
        'nom': 'Old',
        'prenom': 'Name',
      });
      await profileProvider.loadProfile();

      // Mock storage upload
      final mockUploadTask = MockUploadTask();
      when(() => mockAvatarRef.putFile(any(), any())).thenAnswer((_) => mockUploadTask);
      when(() => mockAvatarRef.getDownloadURL()).thenAnswer((_) async => 'http://new.img/url');
      
      when(() => mockUser.updatePhotoURL('http://new.img/url')).thenAnswer((_) async => {});
      when(() => mockUser.reload()).thenAnswer((_) async => {});

      final file = File('dummy.jpg');
      final result = await profileProvider.uploadProfilePicture(file);
      if (!result) {
        print('ERROR: ${profileProvider.errorMessage}');
      }

      expect(result, isTrue);
      expect(profileProvider.profile!.photoUrl, 'http://new.img/url');
      
      final doc = await fakeFirestore.collection('users').doc('user123').get();
      expect(doc.data()!['photoUrl'], 'http://new.img/url');
    });

    test('removeProfilePicture removes photo and updates state', () async {
      // Setup initial profile
      await fakeFirestore.collection('users').doc('user123').set({
        'uid': 'user123',
        'nom': 'Old',
        'prenom': 'Name',
        'photoUrl': 'http://old.img/url'
      });
      await profileProvider.loadProfile();

      when(() => mockAvatarRef.delete()).thenAnswer((_) async => {});
      when(() => mockUser.updatePhotoURL(null)).thenAnswer((_) async => {});
      when(() => mockUser.reload()).thenAnswer((_) async => {});

      final result = await profileProvider.removeProfilePicture();

      expect(result, isTrue);
      expect(profileProvider.profile!.photoUrl, '');
      
      final doc = await fakeFirestore.collection('users').doc('user123').get();
      expect(doc.data()!.containsKey('photoUrl'), isFalse);
    });
  });
}
