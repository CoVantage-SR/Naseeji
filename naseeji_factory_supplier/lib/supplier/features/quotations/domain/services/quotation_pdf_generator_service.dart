import '../entities/create_quotation_form_data.dart';

class QuotationPdfDocument {
  final String quotationId;
  final String fileName;
  final String generatedAtFormatted;
  final String rawPdfContent;

  const QuotationPdfDocument({
    required this.quotationId,
    required this.fileName,
    required this.generatedAtFormatted,
    required this.rawPdfContent,
  });
}

class QuotationPdfGeneratorService {
  QuotationPdfDocument generatePdfDocument(CreateQuotationFormData formData) {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final fileName = 'عرض_سعر_${formData.quotationId}_${formData.rfqId}.pdf';

    final buffer = StringBuffer();
    buffer.writeln('===========================================================');
    buffer.writeln('               منصة نسيجي لسبائك ونُسُج القطن (Naseeji B2B)');
    buffer.writeln('                 عرض سعر موثق رسمياً (Official Quotation)');
    buffer.writeln('===========================================================');
    buffer.writeln('');
    buffer.writeln('بيانات المورد (Supplier):');
    buffer.writeln('• اسم الشركة: شركة نسيج مصر للغزل والنسيج');
    buffer.writeln('• رقم السجل التجاري: 10492837');
    buffer.writeln('• تاريخ الإصدار: $dateStr');
    buffer.writeln('• رقم عرض السعر: ${formData.quotationId}');
    buffer.writeln('• رقم الـ RFQ المرتبط: ${formData.rfqId}');
    buffer.writeln('');
    buffer.writeln('بيانات المصنع المشتري (Buyer Factory):');
    buffer.writeln('• اسم المصنع: ${formData.factoryName}');
    buffer.writeln('• الفئة المطلوبة: ${formData.category}');
    buffer.writeln('');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('                        جدول الأسعار');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('اسم المنتج: ${formData.productName}');
    buffer.writeln('سعر الوحدة: ${formData.unitPrice} ${formData.currency}');
    buffer.writeln('الكمية المطلوبة: ${formData.quantity} وحدة');
    buffer.writeln('الإجمالي قبل الخصم: ${formData.subtotalPrice.toStringAsFixed(0)} ${formData.currency}');
    buffer.writeln('قيمة الخصم المطبق: ${formData.calculatedDiscountAmount.toStringAsFixed(0)} ${formData.currency}');
    buffer.writeln('صافي الإجمالي النهائي: ${formData.netFinalPrice.toStringAsFixed(0)} ${formData.currency}');
    buffer.writeln('');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('                   التصنيع والشرط المالي');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('• مدة الإنتاج والتجهيز: ${formData.productionLeadTime}');
    buffer.writeln('• مدة التعبئة: ${formData.preparationTime}');
    buffer.writeln('• جاهز للاستلام خلال: ${formData.readyForPickupHours} ساعة');
    buffer.writeln('• أقرب موعد للتسليم: ${formData.targetDeliveryDate}');
    buffer.writeln('• طريقة التسديد: ${formData.paymentMethod.arabicLabel}');
    buffer.writeln('• نسبة الدفعة المقدمة: ${formData.advancePaymentPercentage}% (${formData.advancePaymentAmount.toStringAsFixed(0)} ${formData.currency})');
    buffer.writeln('• موعد باقي التسديد: ${formData.balanceDueDate}');
    buffer.writeln('');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('                    ملاحظات ومكان الاستلام');
    buffer.writeln('-----------------------------------------------------------');
    buffer.writeln('• مكان استلام الشحنة: ${formData.pickupLocation}');
    buffer.writeln('• مدة صلاحية العرض: ${formData.validityPeriod}');
    buffer.writeln('• الشروط الخاصة: ${formData.specialTerms}');
    buffer.writeln('• ملاحظات إضافية: ${formData.additionalNotes}');
    buffer.writeln('');
    buffer.writeln('===========================================================');
    buffer.writeln('    ملاحظة: النقل والتسليم يتم عبر شركة الشحن المعتمدة بالمنصة.');
    buffer.writeln('    [ الختم الإلكتروني: موثق بمعرف منصة نسيجي الضامنة 🟢 ]');
    buffer.writeln('===========================================================');

    return QuotationPdfDocument(
      quotationId: formData.quotationId,
      fileName: fileName,
      generatedAtFormatted: dateStr,
      rawPdfContent: buffer.toString(),
    );
  }
}


