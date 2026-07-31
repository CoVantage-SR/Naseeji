enum RfqPriority { low, medium, high, urgent }

enum RfqStatus { newRfq, underReview, quoted, closed, expired }

class RfqItemModel {
  final String id;
  final String title;
  final String buyerName;
  final String fabricType;
  final String quantity;
  final RfqStatus status;
  final RfqPriority priority;
  final DateTime deadline;
  final String remainingTimeFormatted;
  final DateTime createdAt;

  const RfqItemModel({
    required this.id,
    required this.title,
    required this.buyerName,
    required this.fabricType,
    required this.quantity,
    required this.status,
    required this.priority,
    required this.deadline,
    required this.remainingTimeFormatted,
    required this.createdAt,
  });
}



