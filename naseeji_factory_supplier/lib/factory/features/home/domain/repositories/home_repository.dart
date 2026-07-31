import '../entities/home_entities.dart';

abstract class HomeRepository {
  Future<HomeStatistics> getHomeStatistics();
  Future<List<LatestRFQ>> getLatestRFQs();
  Future<List<LatestQuotation>> getLatestQuotations();
  Future<List<CurrentOrder>> getCurrentOrders();
  Future<List<Shipment>> getShipments();
  Future<List<FavoriteSupplier>> getFavoriteSuppliers();
  Future<MonthlyStatistics> getMonthlyStatistics();
  Future<List<RecentActivity>> getRecentActivities();
  Future<List<SmartRecommendation>> getSmartRecommendations();
  Future<List<ActionCenterAlert>> getActionCenterAlerts();
}

