import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../domain/entities/offer_rejected.dart';

class RejectionHeader extends StatelessWidget {
  final OfferRejected details;

  const RejectionHeader({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.cancel,
                    color: Color(0xFFDC2626),
                    size: 56,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFDC2626),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'تم رفض عرض السعر',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'تمت مراجعة عرضك من قبل المصنع الذكي، ولكن لم يتم قبوله في الوقت الحالي.',
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class RejectionNotesCard extends StatelessWidget {
  final OfferRejected details;

  const RejectionNotesCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          top: BorderSide(color: Color(0xFFDC2626), width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'ملاحظات المصنع',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.comment_outlined, color: Color(0xFFDC2626), size: 14),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            details.factoryNotes,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class SuggestedChangesCard extends StatelessWidget {
  final OfferRejected details;

  const SuggestedChangesCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'التغييرات المقترحة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0040E0),
                ),
              ),
              SizedBox(width: 6),
              Container(
                width: 3,
                height: 14,
                color: const Color(0xFF0040E0),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...details.suggestedChanges.map((change) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildSuggestedItem(
                text: change.text,
                icon: _getChangeIcon(change.iconTag),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestedItem({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F1F5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(width: 12),
          Icon(icon, color: const Color(0xFF0040E0), size: 20),
        ],
      ),
    );
  }

  IconData _getChangeIcon(String tag) {
    switch (tag) {
      case 'trending_down':
        return Icons.trending_down_outlined;
      case 'access_time':
        return Icons.access_time_outlined;
      case 'verified':
        return Icons.verified_outlined;
      default:
        return Icons.info_outline;
    }
  }
}

class RejectionActionButtonBar extends StatelessWidget {
  final String rfqId;

  const RejectionActionButtonBar({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => context.push('/create-offer?rfqId=$rfqId'),
              icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
              label: Text(
                'تعديل العرض',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0040E0),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.push('/create-offer?rfqId=$rfqId'),
              icon: const Icon(Icons.send, size: 16, color: Color(0xFF006B5F)),
              label: Text(
                'إرسال عرض جديد',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF006B5F)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.archive_outlined, color: AppColors.onSurfaceVariant, size: 18),
                  label: Text(
                    'أرشفة',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'هل تحتاج للمساعدة في تحسين عرضك؟',
                  style: TextStyle(color: AppColors.outline, fontSize: 11),
                ),
                SizedBox(width: 4),
                Icon(Icons.help_outline, color: AppColors.outline, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
