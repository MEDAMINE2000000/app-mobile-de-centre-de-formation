class Validators {
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre identifiant';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez confirmer votre mot de passe';
      }
      if (value != password) {
        return 'Les mots de passe ne correspondent pas';
      }
      return null;
    };
  }

  static String? lastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre nom';
    }
    return null;
  }

  static String? firstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre prénom';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre e-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez saisir un e-mail valide';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre numéro de téléphone';
    }
    return null;
  }

  static String? birthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre date de naissance';
    }
    return null;
  }
}
