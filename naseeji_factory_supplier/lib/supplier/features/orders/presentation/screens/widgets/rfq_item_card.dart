import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class RfqItemCard extends StatelessWidget {
  final String companyName;
  final String rfqNumber;
  final String material;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final String quantity;
  final String location;
  final String dateLabel;
  final String dateValue;
  final String logoText;
  final Color logoBgColor;
  final String actionButtonText;
  final Color actionButtonColor;
  final Color actionButtonTextColor;
  final bool actionButtonIsOutlined;
  final bool hasIconButton;
  final IconData? iconButtonIcon;
  final VoidCallback? onIconButtonPressed;
  final VoidCallback onActionButtonPressed;

  const RfqItemCard({
    super.key,
    required this.companyName,
    required this.rfqNumber,
    required this.material,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.quantity,
    required this.location,
    required this.dateLabel,
    required this.dateValue,
    required this.logoText,
    required this.logoBgColor,
    required this.actionButtonText,
    required this.actionButtonColor,
    required this.actionButtonTextColor,
    this.actionButtonIsOutlined = false,
    this.hasIconButton = false,
    this.iconButtonIcon,
    this.onIconButtonPressed,
    required this.onActionButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top Header: Logo, Company Name, Specs & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge (far left in RTL layout, wait: Row order is RTL. Let's make it standard Row, since RTL directionality is handled by Directionality widget or ambient locale. Let's design it explicitly or let it flow. To let it flow, we put Status Badge first in Row (which is left in RTL), then Spacer, then Text, then Logo. Or we can use MainAxisAlignment.spaceBetween).
              // Let's use a standard Row with MainAxisAlignment.spaceBetween, and inside the right side we put Logo + Title, and inside the left side we put Badge.
              // Wait, let's check:
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const Spacer(),
              // Title and Specs Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$rfqNumber • $material',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.outline,
                      ),
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.ltr, // Keep code/specs LTR
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Company Logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: logoBgColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: logoBgColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  logoText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: logoBgColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 16),

          // Metadata Grid: Quantity, Location, Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location (Left)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموقع',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.outline,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.outline,
                      ),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Quantity (Right)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الكمية المطلوبة',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.outline,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    quantity,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                dateValue,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '$dateLabel:',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              // Icon button on the left (if enabled)
              if (hasIconButton && iconButtonIcon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      iconButtonIcon,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onIconButtonPressed,
                  ),
                ),
                SizedBox(width: 12),
              ],
              // Main Action Button (Expanded to fill remaining width)
              Expanded(
                child: actionButtonIsOutlined
                    ? OutlinedButton(
                        onPressed: onActionButtonPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: actionButtonColor,
                          side: BorderSide(color: actionButtonColor, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          actionButtonText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: onActionButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actionButtonColor,
                          foregroundColor: actionButtonTextColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          actionButtonText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


