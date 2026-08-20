class ProfileModel {
  final String uid;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String dateNaissance;
  final String? photoUrl; // NEW
  final DateTime? createdAt;

  const ProfileModel({
    required this.uid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.dateNaissance,
    this.photoUrl,
    this.createdAt,
  });

  String get fullName => '$prenom $nom'.trim();

  String get initials {
    final p = prenom.isNotEmpty ? prenom[0] : '';
    final n = nom.isNotEmpty ? nom[0] : '';
    final result = (p + n).toUpperCase();
    return result.isEmpty ? '?' : result;
  }

  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  factory ProfileModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return ProfileModel(
      uid: uid,
      nom: (data['nom'] ?? '') as String,
      prenom: (data['prenom'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      telephone: (data['telephone'] ?? '') as String,
      dateNaissance: (data['dateNaissance'] ?? '') as String,
      photoUrl: data['photoUrl'] as String?, // NEW
      createdAt: data['createdAt'] != null
          ? (data['createdAt']).toDate()
          : null,
    );
  }

  ProfileModel copyWith({
    String? nom,
    String? prenom,
    String? telephone,
    String? dateNaissance,
    String? photoUrl,
  }) {
    return ProfileModel(
      uid: uid,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email,
      telephone: telephone ?? this.telephone,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}
