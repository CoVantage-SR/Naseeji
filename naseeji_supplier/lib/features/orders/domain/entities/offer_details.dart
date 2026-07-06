class OfferPhase {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isActive;
  final bool isFuture;
  final bool showSpinner;
  final bool showPill;

  const OfferPhase({
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    this.isActive = false,
    this.isFuture = false,
    this.showSpinner = false,
    this.showPill = false,
  });
}

class OfferDetails {
  final String rfqId;
  final String statusLabel;
  final String statusDescription;
  final String lastSeen;
  final String sentTimeAgo;
  final List<OfferPhase> phases;
  final String factoryImage;
  final String factoryLabel;

  const OfferDetails({
    required this.rfqId,
    required this.statusLabel,
    required this.statusDescription,
    required this.lastSeen,
    required this.sentTimeAgo,
    required this.phases,
    required this.factoryImage,
    required this.factoryLabel,
  });
}
