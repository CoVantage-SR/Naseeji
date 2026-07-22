import 'package:flutter/material.dart';
import '../../domain/entities/deal_workspace_model.dart';
import 'status_badge_widget.dart';

class ConversationHeaderWidget extends StatelessWidget {
  final DealWorkspaceModel workspace;

  const ConversationHeaderWidget({
    super.key,
    required this.workspace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Factory Avatar with Online Indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(workspace.factoryAvatarUrl),
                  ),
                  if (workspace.isFactoryOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),

              // Factory Name & Online Status Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            workspace.factoryName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (workspace.isFactoryVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified_rounded, size: 16, color: colorScheme.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      workspace.isFactoryOnline ? 'متصل الآن • استجابة خلال دقائق' : 'غير متصل حالياً',
                      style: TextStyle(
                        fontSize: 11,
                        color: workspace.isFactoryOnline ? Colors.green.shade800 : colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),

              // Deal Status Badge
              StatusBadgeWidget(status: workspace.currentStatus),
            ],
          ),
          const SizedBox(height: 10),

          // Order & RFQ Badges Row
          Row(
            children: [
              _buildIdTag(context, label: 'طلب', id: workspace.orderId, icon: Icons.receipt_long_outlined),
              const SizedBox(width: 8),
              _buildIdTag(context, label: 'RFQ', id: workspace.rfqId, icon: Icons.request_quote_outlined),
              const Spacer(),
              Text(
                'مساحة إدارة الصفقة',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdTag(BuildContext context, {required String label, required String id, required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            '$label: $id',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
