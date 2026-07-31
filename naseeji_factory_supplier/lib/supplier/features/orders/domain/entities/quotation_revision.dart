class QuotationRevision {
  final int versionNumber;
  final String createdBy;
  final String date;
  final String time;
  final double price;
  final String notes;
  final String status;

  const QuotationRevision({
    required this.versionNumber,
    required this.createdBy,
    required this.date,
    required this.time,
    required this.price,
    required this.notes,
    required this.status,
  });
}

