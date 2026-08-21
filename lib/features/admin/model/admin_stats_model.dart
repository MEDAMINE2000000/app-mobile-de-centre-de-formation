class AdminStats {
  final int totalUsers;
<<<<<<< HEAD
  final int totalAdmins;
  final int totalNormalUsers;
  final int totalFormations;
  final int pendingInscriptions;
  final int confirmedInscriptions;
  final int rejectedInscriptions;
  final Map<String, int> participantsPerFormation;
  final String mostPopularFormation;

  const AdminStats({
    required this.totalUsers,
    required this.totalAdmins,
    required this.totalNormalUsers,
    required this.totalFormations,
    required this.pendingInscriptions,
    required this.confirmedInscriptions,
    required this.rejectedInscriptions,
    required this.participantsPerFormation,
    required this.mostPopularFormation,
=======
  final int totalFormations;
  final int pendingInscriptions;
  final int confirmedInscriptions;

  const AdminStats({
    required this.totalUsers,
    required this.totalFormations,
    required this.pendingInscriptions,
    required this.confirmedInscriptions,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  });

  factory AdminStats.empty() => const AdminStats(
    totalUsers: 0,
<<<<<<< HEAD
    totalAdmins: 0,
    totalNormalUsers: 0,
    totalFormations: 0,
    pendingInscriptions: 0,
    confirmedInscriptions: 0,
    rejectedInscriptions: 0,
    participantsPerFormation: {},
    mostPopularFormation: '',
=======
    totalFormations: 0,
    pendingInscriptions: 0,
    confirmedInscriptions: 0,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  );
}
