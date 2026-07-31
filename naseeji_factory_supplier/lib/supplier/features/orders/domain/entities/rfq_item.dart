class RfqItem {
  final String companyName;
  final String rfqNumber;
  final String material;
  final String status;
  final int statusColorValue;
  final int statusBgColorValue;
  final String quantity;
  final String location;
  final String dateLabel;
  final String dateValue;
  final String logoText;
  final int logoBgColorValue;
  final String actionButtonText;
  final int actionButtonColorValue;
  final int actionButtonTextColorValue;
  final bool actionButtonIsOutlined;
  final bool hasIconButton;
  final String? iconButtonIconType;

  const RfqItem({
    required this.companyName,
    required this.rfqNumber,
    required this.material,
    required this.status,
    required this.statusColorValue,
    required this.statusBgColorValue,
    required this.quantity,
    required this.location,
    required this.dateLabel,
    required this.dateValue,
    required this.logoText,
    required this.logoBgColorValue,
    required this.actionButtonText,
    required this.actionButtonColorValue,
    required this.actionButtonTextColorValue,
    this.actionButtonIsOutlined = false,
    this.hasIconButton = false,
    this.iconButtonIconType,
  });
}



