import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdminModel {
  final String uid;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String dateNaissance;
  final String role;
  final DateTime? createdAt;

  UserAdminModel({
    required this.uid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.dateNaissance,
    required this.role,
    this.createdAt,
  });

  factory UserAdminModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return UserAdminModel(
      uid: data['uid'] ?? documentId,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      dateNaissance: data['dateNaissance'] ?? '',
      role: data['role'] ?? 'user',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  String get fullName => '${prenom.trim()} ${nom.trim()}'.trim();
  bool get isSuperAdmin =>
      email.trim().toLowerCase() == 'medhammi198@gmail.com';

  UserAdminModel copyWith({
    String? uid,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? dateNaissance,
    String? role,
    DateTime? createdAt,
  }) {
    return UserAdminModel(
      uid: uid ?? this.uid,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
