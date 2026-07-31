import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/factory_home_mock_database.dart';
import '../../domain/entities/factory_home_models.dart';

final factoryDashboardProvider = FutureProvider<FactoryDashboardData>((ref) async {
  return await MockDatabase.getDashboardData();
});

final recentQuotationsProvider = FutureProvider<List<RecentQuotationItem>>((ref) async {
  return await MockDatabase.getRecentQuotations();
});

final rfqProvider = FutureProvider<List<RecentRFQItem>>((ref) async {
  return await MockDatabase.getRecentRFQs();
});

final dealsProvider = FutureProvider<List<ActiveDealItem>>((ref) async {
  return await MockDatabase.getActiveDeals();
});

final suppliersProvider = FutureProvider<List<FavoriteSupplierItem>>((ref) async {
  return await MockDatabase.getFavoriteSuppliers();
});

final notificationsProvider = FutureProvider<List<NotificationPreviewItem>>((ref) async {
  return await MockDatabase.getNotifications();
});

