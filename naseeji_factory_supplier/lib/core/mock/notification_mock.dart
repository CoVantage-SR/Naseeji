class NotificationMock {
  final String id;
  final String dealId;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String category;

  const NotificationMock({
    required this.id,
    required this.dealId,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.category = 'الصفقات',
  });

  static final sampleNotifications = [
    NotificationMock(
      id: 'NOTIF-001',
      dealId: 'DEAL-101',
      title: 'طلب تعديل جديد في الصفقة DEAL-101',
      body: 'طلب المصنع تعديل سعر الوحدة إلى 43 جنيه/كجم مع تسليم سريع خلال 8 أيام.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationMock(
      id: 'NOTIF-002',
      dealId: 'DEAL-102',
      title: 'تم اعتماد العقد الإلكتروني AGR-9920',
      body: 'قام المصنع بالتوقيع والاعتماد وربط المحفظة بالحساب الضامن Escrow 🟢.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
  ];
}


