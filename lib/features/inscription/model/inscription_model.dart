enum InscriptionStatus { pending, confirmed, rejected }

class InscriptionModel {
  final String id;
  final String userId;
  final String formationId;
  final String formationTitle;
  final String formationImageUrl;
  final String formationCategoryName;
  final InscriptionStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? centreNote;

  // User profile information from 'users' collection
  final String? userNom;
  final String? userPrenom;
  final String? userEmail;
  final String? userTelephone;

  const InscriptionModel({
    required this.id,
    required this.userId,
    required this.formationId,
    required this.formationTitle,
    required this.formationImageUrl,
    required this.formationCategoryName,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.centreNote,
    this.userNom,
    this.userPrenom,
    this.userEmail,
    this.userTelephone,
  });

  String get userFullName {
    final prenom = userPrenom ?? '';
    final nom = userNom ?? '';
    final full = '$prenom $nom'.trim();
    return full.isNotEmpty ? full : 'Utilisateur inconnu';
  }

  InscriptionModel copyWith({
    String? id,
    String? userId,
    String? formationId,
    String? formationTitle,
    String? formationImageUrl,
    String? formationCategoryName,
    InscriptionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? centreNote,
    String? userNom,
    String? userPrenom,
    String? userEmail,
    String? userTelephone,
  }) {
    return InscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      formationId: formationId ?? this.formationId,
      formationTitle: formationTitle ?? this.formationTitle,
      formationImageUrl: formationImageUrl ?? this.formationImageUrl,
      formationCategoryName:
          formationCategoryName ?? this.formationCategoryName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      centreNote: centreNote ?? this.centreNote,
      userNom: userNom ?? this.userNom,
      userPrenom: userPrenom ?? this.userPrenom,
      userEmail: userEmail ?? this.userEmail,
      userTelephone: userTelephone ?? this.userTelephone,
    );
  }

  factory InscriptionModel.fromFirestore(
    Map<String, dynamic> data,
    String id, {
    Map<String, dynamic>? userData,
  }) {
    return InscriptionModel(
      id: id,
      userId: (data['userId'] ?? '') as String,
      formationId: (data['formationId'] ?? '') as String,
      formationTitle: (data['formationTitle'] ?? '') as String,
      formationImageUrl: (data['formationImageUrl'] ?? '') as String,
      formationCategoryName: (data['formationCategoryName'] ?? '') as String,
      status: _statusFromString(data['status'] as String?),
      createdAt: data['createdAt'] != null
          ? (data['createdAt']).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt']).toDate()
          : null,
      centreNote: data['centreNote'] as String?,
      userNom: userData?['nom'] as String?,
      userPrenom: userData?['prenom'] as String?,
      userEmail: userData?['email'] as String?,
      userTelephone: userData?['telephone'] as String?,
    );
  }

  static InscriptionStatus _statusFromString(String? value) {
    switch (value) {
      case 'confirmed':
        return InscriptionStatus.confirmed;
      case 'rejected':
        return InscriptionStatus.rejected;
      default:
        return InscriptionStatus.pending;
    }
  }
}
