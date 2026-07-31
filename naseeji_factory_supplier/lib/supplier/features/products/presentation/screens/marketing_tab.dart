import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      ),
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
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFD700),
                              ),
                            ),
                          ),
                          Text(
                            '٧٤٪',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      // Text info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معدل ظهور المنتجات للمصانع',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'درجة ظهور منتجاتك جيدة جداً! قم بإنشاء إعلان ممول لرفع النسبة إلى ٩٩٪.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Statistics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'الإعلانات النشطة',
                        '٣ حملات',
                        Icons.campaign_outlined,
                        Colors.purple,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'مشاهدات الترويج',
                        '١٢.٤ ألف',
                        Icons.visibility_outlined,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'كوبونات مستخدمة',
                        '١٤٠ كوبون',
                        Icons.local_offer_outlined,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Sponsored Products Section
                _buildSectionHeader(
                  context,
                  'الحملات الإعلانية النشطة (Sponsored)',
                ),
                SizedBox(height: 10),
                _buildCampaignCard(
                  context,
                  title: 'ترويج خيوط القطن الفاخر الممتاز',
                  budget: '٥٠ جنيه / يومياً',
                  clicks: '١,٢٥٠ نقرة',
                  status: 'نشط',
                  color: Colors.green,
                ),
                SizedBox(height: 10),
                _buildCampaignCard(
                  context,
                  title: 'إعلان نسيج الصوف المخلوط الموسمي',
                  budget: '٣٠ جنيه / يومياً',
                  clicks: '٤٢٠ نقرة',
                  status: 'موقت',
                  color: Colors.orange,
                ),

                SizedBox(height: 20),

                // Coupons Section
                _buildSectionHeader(context, 'الكوبونات وعروض الخصم الحالية'),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFC7D2FE),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text(
                          'COTTON20',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'خصم ٢٠٪ على قماش القطن الطبيعي',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'تاريخ الانتهاء: 2026-08-30 · الحد الأدنى: 5000 جنيه',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Factory Broadcast Option
                _buildSectionHeader(
                  context,
                  'بث العروض للمصانع (Factory Broadcast)',
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.broadcast_on_personal,
                          color: Colors.green.shade700,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'بث مباشر لعرض فوري للمصانع',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'أرسل إعلان منتجاتك لأكثر من ٥٠ مصنع نشط الآن بنقرة واحدة.',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: Text(
                          'بدء البث',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, color: AppColors.outline)),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(
    BuildContext context, {
    required String title,
    required String budget,
    required String clicks,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'الميزانية: $budget',
                      style: TextStyle(fontSize: 10, color: AppColors.outline),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'النقرات: $clicks',
                      style: TextStyle(fontSize: 10, color: AppColors.outline),
                    ),
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
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



