import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class RfqScreen extends StatelessWidget {
  const RfqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عروض الأسعار (RFQ)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondaryLight,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(text: 'الجديدة'),
                      Tab(text: 'المقدمة'),
                      Tab(text: 'الملغية'),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.hLG,
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.request_quote_rounded,
                      size: 64,
                      color: AppColors.textSecondaryDark,
                    ),
                    AppSpacing.hMD,
                    Text(
                      'لا توجد طلبات عروض أسعار جديدة',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.hXS,
                    Text(
                      'عندما يرسل العملاء طلبات عروض أسعار ستظهر هنا مباشرة.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
