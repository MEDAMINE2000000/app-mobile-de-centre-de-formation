import 'package:flutter_test/flutter_test.dart';
import 'package:three_alfa_mobile_app/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('username validator', () {
      test('should return error if empty', () {
        expect(Validators.username(''), 'Veuillez saisir votre identifiant');
        expect(Validators.username(null), 'Veuillez saisir votre identifiant');
      });

      test('should return null if valid', () {
        expect(Validators.username('user123'), isNull);
      });
    });

    group('password validator', () {
      test('should return error if empty', () {
        expect(Validators.password(''), 'Veuillez saisir votre mot de passe');
        expect(Validators.password(null), 'Veuillez saisir votre mot de passe');
      });

      test('should return error if less than 6 characters', () {
        expect(Validators.password('12345'), 'Le mot de passe doit contenir au moins 6 caractères');
      });

      test('should return null if valid', () {
        expect(Validators.password('123456'), isNull);
      });
    });

    group('confirmPassword validator', () {
      final confirm = Validators.confirmPassword('password123');

      test('should return error if empty', () {
        expect(confirm(''), 'Veuillez confirmer votre mot de passe');
        expect(confirm(null), 'Veuillez confirmer votre mot de passe');
      });

      test('should return error if passwords do not match', () {
        expect(confirm('differentPassword'), 'Les mots de passe ne correspondent pas');
      });

      test('should return null if passwords match', () {
        expect(confirm('password123'), isNull);
      });
    });

    group('lastName validator', () {
      test('should return error if empty', () {
        expect(Validators.lastName(''), 'Veuillez saisir votre nom');
        expect(Validators.lastName(null), 'Veuillez saisir votre nom');
      });

      test('should return null if valid', () {
        expect(Validators.lastName('Doe'), isNull);
      });
    });

    group('firstName validator', () {
      test('should return error if empty', () {
        expect(Validators.firstName(''), 'Veuillez saisir votre prénom');
        expect(Validators.firstName(null), 'Veuillez saisir votre prénom');
      });

      test('should return null if valid', () {
        expect(Validators.firstName('John'), isNull);
      });
    });

    group('email validator', () {
      test('should return error if empty', () {
        expect(Validators.email(''), 'Veuillez saisir votre e-mail');
        expect(Validators.email(null), 'Veuillez saisir votre e-mail');
      });

      test('should return error if invalid format', () {
        expect(Validators.email('invalid-email'), 'Veuillez saisir un e-mail valide');
        expect(Validators.email('test@'), 'Veuillez saisir un e-mail valide');
        expect(Validators.email('@domain.com'), 'Veuillez saisir un e-mail valide');
      });

      test('should return null if valid', () {
        expect(Validators.email('test@example.com'), isNull);
      });
    });

    group('phone validator', () {
      test('should return error if empty', () {
        expect(Validators.phone(''), 'Veuillez saisir votre numéro de téléphone');
        expect(Validators.phone(null), 'Veuillez saisir votre numéro de téléphone');
      });

      test('should return null if valid', () {
        expect(Validators.phone('12345678'), isNull);
      });
    });

    group('birthDate validator', () {
      test('should return error if empty', () {
        expect(Validators.birthDate(''), 'Veuillez saisir votre date de naissance');
        expect(Validators.birthDate(null), 'Veuillez saisir votre date de naissance');
      });

      test('should return null if valid', () {
        expect(Validators.birthDate('01/01/2000'), isNull);
      });
    });
  });
}
