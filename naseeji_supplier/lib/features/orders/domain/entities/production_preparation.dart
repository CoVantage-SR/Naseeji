class ProductionPreparation {
  final String rfqId;
  final double progressPercent;
  final String currentPhase;
  final String estimatedFinishDate;
  final List<String> preparationImages;
  final String? productVideoUrl;
  final List<String> qualityInspectionImages;
  final List<String> packagingImages;
  final String preparationNotes;

  const ProductionPreparation({
    required this.rfqId,
    required this.progressPercent,
    required this.currentPhase,
    required this.estimatedFinishDate,
    required this.preparationImages,
    this.productVideoUrl,
    required this.qualityInspectionImages,
    required this.packagingImages,
    required this.preparationNotes,
  });
}
