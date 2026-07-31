class ActivityLogItem {
  final String iconTag;
  final String user;
  final String action;
  final String date;
  final String time;
  final String device;
  final List<String>? attachments;
  final String status;

  const ActivityLogItem({
    required this.iconTag,
    required this.user,
    required this.action,
    required this.date,
    required this.time,
    required this.device,
    this.attachments,
    required this.status,
  });
}



