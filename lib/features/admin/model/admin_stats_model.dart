class AdminStats {
  final int totalUsers;
  final int totalFormations;
  final int pendingInscriptions;
  final int confirmedInscriptions;

  const AdminStats({
    required this.totalUsers,
    required this.totalFormations,
    required this.pendingInscriptions,
    required this.confirmedInscriptions,
  });

  factory AdminStats.empty() => const AdminStats(
    totalUsers: 0,
    totalFormations: 0,
    pendingInscriptions: 0,
    confirmedInscriptions: 0,
  );
}
