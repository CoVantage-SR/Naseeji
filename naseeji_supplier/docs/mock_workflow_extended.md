# 📚 دليل الـ Mock Workflow الممتد (Extended Mock Workflow Architecture)
## تطبيق نسيجي للموردين — NASEEJI Supplier App

---

## 📌 التفاصيل الهيكلية الكاملة لموديلات وكيانات النظام الموحد

### 1. كيان الصفقة الرئيسي (`DealMock` & `DealWorkspaceModel`)
- **المعرف الموحد**: `dealId` (مثل: `DEAL-101`).
- **بيانات المورد**: `supplierId`, `supplierName`.
- **بيانات المصنع**: `factoryName`, `factoryAvatarUrl`, `isFactoryOnline`, `isFactoryVerified`.
- **بيانات المنتج والخامة**: `productId`, `productName`, `dealValue`, `totalQuantity`.
- **البيانات الفرعية المربوطة**:
  - قائمة الرسائل الشات (`messages`).
  - قائمة عروض الأسعار للإصدارات (`quotationHistory` & `latestQuotation`).
  - العقد التوثيقي (`finalAgreement`).
  - أرشيف الملفات (`files`).
  - الخط الزمني للتتبع (`timeline`).

---

## 🔄 سيناريوهات المعالجة التفاعلية (Interactive Execution Scenarios)

### السيناريو أ: المورد يقدم عرضاً مخصصاً جديداً (Custom Counter Offer)
1. يفتح المورد نافذة `RequestModificationBottomSheet`.
2. يتم فحص الملاحظات بمحرك الفلترة والأمان `ContentModerationService`.
3. يُنشئ النظام كائن `QuotationMock` برقم الإصدار `V2`.
4. يُحدث النظام السعر والحالة في `MockDatabase.deals`.
5. تُرسل رسالة نظام وتُضاف المرحلة في `Timeline`.
6. تتحدث شاشة `BusinessChatScreen` والـ Header فوراً وبشكل حركي سلس.

### السيناريو ب: قبول وتوثيق العقد الإلكتروني (Agreement Contract Execution)
1. يتم النقر على زر "قبول العرض" في `NegotiationCardWidget`.
2. تُنشأ وثيقة العقد `AgreementMock` ببيانات الطرفين والشروط المالية وتسليم المحلة الكبرى.
3. تظهر علامة الصح الخضراء والختم المعتمد بتبويب **📄 الاتفاق**.
