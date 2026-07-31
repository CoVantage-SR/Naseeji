class ShippingManifest {
  final String rfqId;
  final String shippingCompany;
  final String trackingNumber;
  final String shipmentNumber;
  final String truckNumber;
  final String driverName;
  final String expectedArrival;
  final List<String> beforeLoadingImages;
  final List<String> afterLoadingImages;
  final String shippingLabelUrl;
  final String invoiceUrl;
  final String deliveryDocsUrl;
  final String? shipmentVideoUrl;

  const ShippingManifest({
    required this.rfqId,
    required this.shippingCompany,
    required this.trackingNumber,
    required this.shipmentNumber,
    required this.truckNumber,
    required this.driverName,
    required this.expectedArrival,
    required this.beforeLoadingImages,
    required this.afterLoadingImages,
    required this.shippingLabelUrl,
    required this.invoiceUrl,
    required this.deliveryDocsUrl,
    this.shipmentVideoUrl,
  });
}



