import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_form_data.dart';
import '../widgets/subscription/subscription_limit_dialog.dart';

class AddProductWizardController extends StateNotifier<ProductFormData> {
  AddProductWizardController() : super(const ProductFormData());

  void updateBasicInfo({
    String? name,
    String? category,
    String? subCategory,
    String? shortDescription,
    String? fullDescription,
    String? countryOfOrigin,
    String? brand,
  }) {
    state = state.copyWith(
      name: name,
      category: category,
      subCategory: subCategory,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      countryOfOrigin: countryOfOrigin,
      brand: brand,
      isDraftSaved: false,
    );
  }

  void addTechSpec(String key, String val) {
    if (key.trim().isEmpty || val.trim().isEmpty) return;
    final updated = Map<String, String>.from(state.technicalSpecs)..[key] = val;
    state = state.copyWith(technicalSpecs: updated, isDraftSaved: false);
  }

  void removeTechSpec(String key) {
    final updated = Map<String, String>.from(state.technicalSpecs)..remove(key);
    state = state.copyWith(technicalSpecs: updated, isDraftSaved: false);
  }

  void setMainImage(String url) {
    if (state.usedImagesCount >= state.maxImagesAllowed) {
      return;
    }
    state = state.copyWith(mainCoverImage: url, isDraftSaved: false);
  }

  void addAdditionalImage(String url, BuildContext context) {
    if (state.additionalImages.length + 1 >= state.maxImagesAllowed) {
      SubscriptionLimitDialog.show(
        context,
        title: 'لقد وصلت للحد الأقصى للصور في باقتك',
        message: 'باقتك الحالية تسمح برفع حتى ${state.maxImagesAllowed} صور فقط للمنتج.',
      );
      return;
    }
    final updated = List<String>.from(state.additionalImages)..add(url);
    state = state.copyWith(
      additionalImages: updated,
      usedImagesCount: updated.length + (state.mainCoverImage != null ? 1 : 0),
      isDraftSaved: false,
    );
  }

  void removeAdditionalImage(int index) {
    if (index >= 0 && index < state.additionalImages.length) {
      final updated = List<String>.from(state.additionalImages)..removeAt(index);
      state = state.copyWith(
        additionalImages: updated,
        usedImagesCount: updated.length + (state.mainCoverImage != null ? 1 : 0),
        isDraftSaved: false,
      );
    }
  }

  void setVideo(String url, String fileName, String duration, double sizeMb, BuildContext context) {
    if (state.usedVideosCount >= state.maxVideosAllowed) {
      SubscriptionLimitDialog.show(
        context,
        title: 'لقد وصلت للحد الأقصى للفيديوهات',
        message: 'باقتك الحالية تسمح برفع فيديو واحد فقط للمنتج.',
      );
      return;
    }
    state = state.copyWith(
      videoUrl: url,
      videoFileName: fileName,
      videoDuration: duration,
      videoSizeMb: sizeMb,
      usedVideosCount: 1,
      isDraftSaved: false,
    );
  }

  void removeVideo() {
    state = state.copyWith(
      videoUrl: null,
      videoFileName: null,
      usedVideosCount: 0,
      isDraftSaved: false,
    );
  }

  void addPdfDocument(String title, String size, BuildContext context) {
    if (state.pdfDocuments.length >= state.maxPdfsAllowed) {
      SubscriptionLimitDialog.show(
        context,
        title: 'لقد وصلت للحد الأقصى لملفات الـ PDF',
        message: 'باقتك الحالية تسمح برفع حتى ${state.maxPdfsAllowed} ملفات PDF للمنتج.',
      );
      return;
    }
    final updated = List<Map<String, String>>.from(state.pdfDocuments)
      ..add({'title': title, 'size': size});
    state = state.copyWith(
      pdfDocuments: updated,
      usedPdfsCount: updated.length,
      isDraftSaved: false,
    );
  }

  void removePdfDocument(int index) {
    if (index >= 0 && index < state.pdfDocuments.length) {
      final updated = List<Map<String, String>>.from(state.pdfDocuments)..removeAt(index);
      state = state.copyWith(
        pdfDocuments: updated,
        usedPdfsCount: updated.length,
        isDraftSaved: false,
      );
    }
  }

  void addTierPrice(int qty, double price) {
    if (qty <= 0 || price <= 0) return;
    final updated = List<Map<String, dynamic>>.from(state.tieredPrices)
      ..add({'quantity': qty, 'price': price});
    updated.sort((a, b) => (a['quantity'] as int).compareTo(b['quantity'] as int));
    state = state.copyWith(tieredPrices: updated, isDraftSaved: false);
  }

  void removeTierPrice(int index) {
    if (index >= 0 && index < state.tieredPrices.length) {
      final updated = List<Map<String, dynamic>>.from(state.tieredPrices)..removeAt(index);
      state = state.copyWith(tieredPrices: updated, isDraftSaved: false);
    }
  }

  void updatePricingDetails({
    int? moq,
    int? maxQuantity,
    String? wholesaleDiscounts,
    String? priceValidityPeriod,
  }) {
    state = state.copyWith(
      moq: moq,
      maxQuantity: maxQuantity,
      wholesaleDiscounts: wholesaleDiscounts,
      priceValidityPeriod: priceValidityPeriod,
      isDraftSaved: false,
    );
  }

  void updateManufacturingLogistics({
    int? availableStock,
    String? dailyCapacity,
    String? monthlyCapacity,
    String? manufacturingLeadTime,
    String? preparationTime,
    int? readyForShipmentHours,
    String? pickupLocation,
  }) {
    state = state.copyWith(
      availableStock: availableStock,
      dailyCapacity: dailyCapacity,
      monthlyCapacity: monthlyCapacity,
      manufacturingLeadTime: manufacturingLeadTime,
      preparationTime: preparationTime,
      readyForShipmentHours: readyForShipmentHours,
      pickupLocation: pickupLocation,
      isDraftSaved: false,
    );
  }

  bool nextStep(BuildContext context) {
    if (!state.isStepValid(state.currentStep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برجاء استكمال كافة الحقول المطلوبة في هذه الخطوة أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (state.currentStep < 8) {
      saveDraftSilent();
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  void previousStep() {
    if (state.currentStep > 1) {
      saveDraftSilent();
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 8) {
      saveDraftSilent();
      state = state.copyWith(currentStep: step);
    }
  }

  void saveDraftSilent() {
    state = state.copyWith(
      isDraftSaved: true,
      lastSavedAt: DateTime.now(),
    );
  }

  void saveDraftManual(BuildContext context) {
    saveDraftSilent();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ بيانات المنتج كمسودة بنجاح! يمكنك العودة لاستكمالها في أي وقت.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void publishProduct(BuildContext context) {
    if (!state.isReadyForPublish) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر النشر: برجاء التأكد من استكمال الصورة الرئيسية والسعر واشتراطات الباقة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('مبروك! تم نشر المنتج بنجاح وأصبح ظاهراً لكافة المصانع والمشتريين.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    context.go('/products/details/prod-101');
  }
}

final addProductControllerProvider =
    StateNotifierProvider.autoDispose<AddProductWizardController, ProductFormData>((ref) {
  return AddProductWizardController();
});


