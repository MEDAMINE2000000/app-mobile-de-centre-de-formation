import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late AdminProvider adminProvider;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    adminProvider = AdminProvider(db: fakeFirestore);
  });

  group('AdminProvider Tests', () {
    test('loadAllUsers fetches users', () async {
      await fakeFirestore.collection('users').doc('user1').set({
        'email': 'user1@example.com',
        'role': 'user',
        'isSuperAdmin': false,
        'nom': 'Doe',
        'prenom': 'John',
        'telephone': '1234567890',
        'createdAt': DateTime.now(),
      });

      await adminProvider.loadAllUsers();

      expect(adminProvider.isLoadingUsers, isFalse);
      expect(adminProvider.allUsers.length, 1);
      expect(adminProvider.allUsers.first.email, 'user1@example.com');
    });

    test('updateUserRole updates role but fails for super admin', () async {
      await fakeFirestore.collection('users').doc('superadmin').set({
        'email': 'medhammi198@gmail.com',
        'role': 'admin',
        'nom': 'Super',
        'prenom': 'Admin',
        'telephone': '000000',
        'createdAt': DateTime.now(),
      });

      await fakeFirestore.collection('users').doc('normaluser').set({
        'email': 'normal@example.com',
        'role': 'user',
        'isSuperAdmin': false,
        'nom': 'Normal',
        'prenom': 'User',
        'telephone': '111111',
        'createdAt': DateTime.now(),
      });

      await adminProvider.loadAllUsers();

      // Attempt to update super admin
      bool superResult = await adminProvider.updateUserRole('superadmin', 'user');
      expect(superResult, isFalse);
      expect(adminProvider.errorMessage, contains('Super Administrateur'));

      // Attempt to update normal user
      bool normalResult = await adminProvider.updateUserRole('normaluser', 'admin');
      expect(normalResult, isTrue);

      final doc = await fakeFirestore.collection('users').doc('normaluser').get();
      expect(doc.data()?['role'], 'admin');
    });

    test('loadStats calculates statistics', () async {
      // Add users
      await fakeFirestore.collection('users').doc('u1').set({'role': 'admin'});
      await fakeFirestore.collection('users').doc('u2').set({'role': 'user'});
      await fakeFirestore.collection('users').doc('u3').set({'role': 'user'});

      // Add inscriptions
      await fakeFirestore.collection('inscriptions').doc('i1').set({'status': 'pending', 'formationId': 'f1'});
      await fakeFirestore.collection('inscriptions').doc('i2').set({'status': 'confirmed', 'formationId': 'f1'});
      await fakeFirestore.collection('inscriptions').doc('i3').set({'status': 'rejected', 'formationId': 'f2'});
      await fakeFirestore.collection('inscriptions').doc('i4').set({'status': 'confirmed', 'formationId': 'f2'});

      await adminProvider.loadStats();
      // wait a bit for streams
      await Future.delayed(const Duration(milliseconds: 200));

      final stats = adminProvider.stats;
      expect(stats.totalUsers, 3);
      expect(stats.totalAdmins, 1);
      expect(stats.totalNormalUsers, 2);
      
      expect(stats.pendingInscriptions, 1);
      expect(stats.confirmedInscriptions, 2);
      expect(stats.rejectedInscriptions, 1);
    });
  });
}
