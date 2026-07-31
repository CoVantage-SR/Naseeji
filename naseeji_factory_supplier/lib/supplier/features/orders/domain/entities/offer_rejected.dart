class SuggestedChange {
  final String text;
  final String iconTag;

  const SuggestedChange({
    required this.text,
    required this.iconTag,
  });
}

class OfferRejected {
  final String rfqId;
  final String factoryNotes;
  final List<SuggestedChange> suggestedChanges;
  final String standardsImage;
  final String standardsLabel;

  const OfferRejected({
    required this.rfqId,
    required this.factoryNotes,
    required this.suggestedChanges,
    required this.standardsImage,
    required this.standardsLabel,
  });
}


