class ProductSubscriptionLimitModel {
  final String currentPlan;
  final int maxProducts;
  final int usedProducts;
  final int remainingProducts;
  final int maxImagesPerProduct;
  final int usedImages;
  final int remainingImages;
  final int maxVideosPerProduct;
  final int usedVideos;
  final int remainingVideos;
  final int maxPdfsPerProduct;
  final int usedPdfs;
  final int remainingPdfs;
  final int maxRfqs;
  final int usedRfqs;
  final int remainingRfqs;

  final bool isExpired;

  const ProductSubscriptionLimitModel({
    required this.currentPlan,
    required this.maxProducts,
    required this.usedProducts,
    required this.remainingProducts,
    required this.maxImagesPerProduct,
    required this.usedImages,
    required this.remainingImages,
    required this.maxVideosPerProduct,
    required this.usedVideos,
    required this.remainingVideos,
    required this.maxPdfsPerProduct,
    required this.usedPdfs,
    required this.remainingPdfs,
    required this.maxRfqs,
    required this.usedRfqs,
    required this.remainingRfqs,
    this.isExpired = false,
  });

  bool get canAddProduct => remainingProducts > 0;
  bool get canAddImage => remainingImages > 0;
  bool get canAddVideo => remainingVideos > 0;
  bool get canAddPdf => remainingPdfs > 0;
}
