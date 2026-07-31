// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;
  final VoidCallback? onChat;
  final VoidCallback? onOrders;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
    this.onChat,
    this.onOrders,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 2))],
          border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _buildLogo(),
                  SizedBox(width: 12),
                  Expanded(child: _buildInfo()),
                  _buildStatusBadge(),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.surfaceContainerLow),
            // ── Stats Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  _buildStat('الطلبات', customer.totalOrders.toString(), Icons.shopping_bag_outlined),
                  _buildDivider(),
                  _buildStat('الإيرادات', _formatRevenue(customer.totalRevenue), Icons.payments_outlined),
                  _buildDivider(),
                  _buildStat('التقييم', customer.rating.toStringAsFixed(1), Icons.star_rounded, color: const Color(0xFFFFB800)),
                ],
              ),
            ),
            // ── Tags ──
            if (customer.tags.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: SizedBox(
                  height: 24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: customer.tags.length,
                    separatorBuilder: (_, __) => SizedBox(width: 6),
                    itemBuilder: (_, i) {
                      final tag = customer.tags[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(tag.colorValue).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(tag.colorValue).withValues(alpha: 0.3), width: 0.5),
                        ),
                        child: Text(
                          tag.label,
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(tag.colorValue)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            // ── Quick Actions ──
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton('عرض الملف', Icons.person_outlined, onTap),
                  SizedBox(width: 8),
                  _buildActionButton('محادثة', Icons.forum_outlined, onChat),
                  SizedBox(width: 8),
                  _buildActionButton('الطلبات', Icons.shopping_bag_outlined, onOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Color(customer.logoBgColorValue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          customer.logoText,
          style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                customer.factoryName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (customer.isVerified) ...[
              SizedBox(width: 4),
              const Icon(Icons.verified, size: 14, color: AppColors.primary),
            ],
          ],
        ),
        SizedBox(height: 2),
        Text(
          '${customer.city}، ${customer.country}',
          style: TextStyle(fontSize: 10, color: AppColors.outline),
        ),
        SizedBox(height: 2),
        Text(
          customer.businessCategory,
          style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final statusData = _getStatusData();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.$2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusData.$1,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusData.$2),
      ),
    );
  }

  (String, Color) _getStatusData() {
    switch (customer.status) {
      case CustomerStatus.vip:
        return ('VIP', const Color(0xFFFFB800));
      case CustomerStatus.active:
        return ('نشط', Colors.green);
      case CustomerStatus.newCustomer:
        return ('جديد', AppColors.primary);
      case CustomerStatus.inactive:
        return ('غير نشط', AppColors.outline);
      case CustomerStatus.blocked:
        return ('محظور', AppColors.error);
    }
  }

  Widget _buildStat(String label, String value, IconData icon, {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.primary),
          SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: TextStyle(fontSize: 8, color: AppColors.outline)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 0.5, height: 30, color: AppColors.surfaceContainerLow);
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback? onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 13, color: AppColors.primary),
      label: Text(label, style: TextStyle(fontSize: 9, color: AppColors.primary)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
    );
  }

  String _formatRevenue(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}م';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}ك';
    return amount.toStringAsFixed(0);
  }
}

