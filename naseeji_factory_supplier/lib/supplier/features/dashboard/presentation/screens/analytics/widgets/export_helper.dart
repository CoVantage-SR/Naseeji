import 'package:flutter/material.dart';

class ExportHelper {
  static void showExportBottomSheet(BuildContext context, String reportName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تصدير تقرير: $reportName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('تصدير كملف PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateExport(context, 'PDF');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart, color: Colors.green),
                  title: const Text('تصدير كملف Excel (xlsx)'),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateExport(context, 'Excel');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: const Text('تصدير كملف CSV'),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateExport(context, 'CSV');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.print, color: Colors.grey),
                  title: const Text('طباعة التقرير'),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateExport(context, 'طباعة');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.indigo),
                  title: const Text('مشاركة التقرير مع الآخرين'),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateExport(context, 'مشاركة');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _simulateExport(BuildContext context, String format) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: Card(
            margin: EdgeInsets.all(32),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'جاري تجهيز وتصدير البيانات...',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              format == 'طباعة'
                  ? 'تم إرسال التقرير إلى الطابعة بنجاح!'
                  : format == 'مشاركة'
                      ? 'تم تجهيز رابط المشاركة بنجاح!'
                      : 'تم تصدير التقرير بصيغة $format وحفظه بنجاح!',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }
}



