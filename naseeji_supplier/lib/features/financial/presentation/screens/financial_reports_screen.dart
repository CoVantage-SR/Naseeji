import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/financial_controllers.dart';

class FinancialReportsScreen extends ConsumerStatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  ConsumerState<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends ConsumerState<FinancialReportsScreen> {
  String _selectedReportType = 'تقرير المبيعات والإيرادات';
  String _selectedFormat = 'PDF';
  DateTimeRange? _selectedDateRange;
  bool _isGenerating = false;

  final List<String> _reportTypes = [
    'تقرير المبيعات والإيرادات',
    'تقرير الأرباح والخسائر',
    'تقرير المدفوعات والتسويات',
    'تقرير سحوبات الحساب البنكي',
    'كشف ضريبة القيمة المضافة',
    'تقرير تحليل المصروفات والرسوم',
    'تقرير الضمان وحماية الدفعات (Escrow)',
  ];

  final List<String> _formats = ['PDF', 'Excel (XLSX)', 'CSV'];

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(financialReportsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'مركز التقارير المالية',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isGenerating,
        child: Container(
          color: const Color(0xFFF8F9FF),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'إعداد وتصدير تقرير مالي جديد',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 16),

                      // Select Report Type
                      const Text(
                        'نوع التقرير المالي',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: AppColors.outline),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedReportType,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFF8F9FF),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                        items: _reportTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(type, style: const TextStyle(fontSize: 13)),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedReportType = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Range Selection
                      const Text(
                        'الفترة الزمنية للتقرير',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: AppColors.outline),
                      ),
                      const SizedBox(height: 6),
                      OutlinedButton.icon(
                        onPressed: _pickDateRange,
                        icon: const Icon(Icons.date_range, size: 18),
                        label: Text(
                          _selectedDateRange == null
                              ? 'اختر النطاق الزمني للتقرير'
                              : '${_selectedDateRange!.end.year}-${_selectedDateRange!.end.month}-${_selectedDateRange!.end.day} إلى ${_selectedDateRange!.start.year}-${_selectedDateRange!.start.month}-${_selectedDateRange!.start.day}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: AppColors.outlineVariant),
                          foregroundColor: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Select Format
                      const Text(
                        'صيغة تصدير الملف',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: AppColors.outline),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedFormat,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFF8F9FF),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                        items: _formats.map((fmt) {
                          return DropdownMenuItem(
                            value: fmt,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(fmt, style: const TextStyle(fontSize: 13)),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedFormat = val);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Generate button
                      PrimaryButton(
                        text: 'توليد وتنزيل التقرير',
                        onPressed: () async {
                          if (_selectedDateRange == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('يرجى تحديد النطاق الزمني للتقرير أولاً')),
                            );
                            return;
                          }
                          setState(() => _isGenerating = true);
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() => _isGenerating = false);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم توليد تقرير "$_selectedReportType" وتنزيله بنجاح بصيغة $_selectedFormat.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reports History List
                const Text(
                  'التقارير الجاهزة والسابقة',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 10),

                reportsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('خطأ: $err')),
                  data: (reports) {
                    if (reports.isEmpty) {
                      return const Center(child: Text('لا توجد تقارير سابقة متاحة'));
                    }
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: List.generate(reports.length, (index) {
                          final report = reports[index];
                          final dateStr = '${report.createdDate.year}-${report.createdDate.month.toString().padLeft(2, '0')}-${report.createdDate.day.toString().padLeft(2, '0')}';

                          return ListTile(
                            leading: const Icon(Icons.picture_as_pdf, color: Color(0xFFBA1A1A)),
                            title: Text(report.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                            subtitle: Text('الحجم: ${report.size} | تاريخ التوليد: $dateStr', style: const TextStyle(fontSize: 10), textAlign: TextAlign.right),
                            trailing: IconButton(
                              icon: const Icon(Icons.download, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تحميل الملف ${report.title}...')),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      locale: const Locale('ar'),
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }
}
