import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../widgets/vip_feature_guard.dart';

class MarketingTab extends StatelessWidget {
  final VoidCallback? onCancelVip;

  const MarketingTab({super.key, this.onCancelVip});

  @override
  Widget build(BuildContext context) {
    return VipFeatureGuard(
      onCancelTap: onCancelVip,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Visibility Score Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Visibility Score Gauge
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: 0.74,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                            ),
                          ),
                          const Text(
                            '٧٤٪',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Text info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'معدل ظهور المنتجات للمصانع',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'درجة ظهور منتجاتك جيدة جداً! قم بإنشاء إعلان ممول لرفع النسبة إلى ٩٩٪.',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Statistics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('الإعلانات النشطة', '٣ حملات', Icons.campaign_outlined, Colors.purple),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard('مشاهدات الترويج', '١٢.٤ ألف', Icons.visibility_outlined, Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard('كوبونات مستخدمة', '١٤٠ كوبون', Icons.local_offer_outlined, Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sponsored Products Section
                _buildSectionHeader('الحملات الإعلانية النشطة (Sponsored)'),
                const SizedBox(height: 10),
                _buildCampaignCard(
                  title: 'ترويج خيوط القطن الفاخر الممتاز',
                  budget: '٥٠ ر.س / يومياً',
                  clicks: '١,٢٥٠ نقرة',
                  status: 'نشط',
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                _buildCampaignCard(
                  title: 'إعلان نسيج الصوف المخلوط الموسمي',
                  budget: '٣٠ ر.س / يومياً',
                  clicks: '٤٢٠ نقرة',
                  status: 'موقت',
                  color: Colors.orange,
                ),

                const SizedBox(height: 20),

                // Coupons Section
                _buildSectionHeader('الكوبونات وعروض الخصم الحالية'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC7D2FE), style: BorderStyle.solid),
                        ),
                        child: const Text(
                          'COTTON20',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('خصم ٢٠٪ على قماش القطن الطبيعي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(height: 2),
                            Text('تاريخ الانتهاء: 2026-08-30 · الحد الأدنى: 5000 ر.س', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Factory Broadcast Option
                _buildSectionHeader('بث العروض للمصانع (Factory Broadcast)'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.broadcast_on_personal, color: Colors.green.shade700, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('بث مباشر لعرض فوري للمصانع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(height: 2),
                            Text('أرسل إعلان منتجاتك لأكثر من ٥٠ مصنع نشط الآن بنقرة واحدة.', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('بدء البث', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard({
    required String title,
    required String budget,
    required String clicks,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('الميزانية: $budget', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                    const SizedBox(width: 12),
                    Text('النقرات: $clicks', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
