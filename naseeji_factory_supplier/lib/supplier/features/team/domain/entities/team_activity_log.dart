class TeamActivityLog {
  final String id;
  final String memberId;
  final String memberName;
  final String action;
  final String description;
  final DateTime timestamp;

  const TeamActivityLog({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.action,
    required this.description,
    required this.timestamp,
  });

  String get formattedTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }
}
