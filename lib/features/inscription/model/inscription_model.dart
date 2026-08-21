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

<<<<<<< HEAD
  /// true when the user has acknowledged the centre's decision (clicked « ✓ Lu »)
  final bool decisionRead;

  /// timestamp when the user clicked « ✓ Lu »
  final DateTime? readAt;

=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
    this.decisionRead = false,
    this.readAt,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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

<<<<<<< HEAD
  /// Returns true if this inscription has a final decision (confirmed or rejected)
  /// and the user has NOT yet acknowledged it.
  bool get hasUnreadDecision {
    return (status == InscriptionStatus.confirmed ||
            status == InscriptionStatus.rejected) &&
        !decisionRead;
  }

=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
    bool? decisionRead,
    DateTime? readAt,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
      decisionRead: decisionRead ?? this.decisionRead,
      readAt: readAt ?? this.readAt,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
      decisionRead: (data['decisionRead'] as bool?) ?? false,
      readAt: data['readAt'] != null ? (data['readAt']).toDate() : null,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
