# 🖥️ جدول ربط الشاشات بالأزرار والتعديلات (Screen Actions Matrix)
## تطبيق نسيجي للموردين — NASEEJI Supplier App

---

## 📌 جدول الربط التكاملي المباشر (Screen -> Widget -> Button -> Action -> Impact)

| Screen | Widget | Button | Action Method | Updated Data (SSOT) | Updated Providers | Updated Screens | System Message | Notification |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`ProductsScreen`** | `ProductCard` | طلب عرض | `createNewDealFromProduct` | `MockDatabase.deals`, `chats` | `dealProvider`, `messagesController` | `BusinessChatScreen`, `MessagesScreen` | تم إنشاء الصفقة | طلب RFQ جديد |
| **`BusinessChatScreen`** | `MessageInputWidget` | إرسال عرض | `submitNewOfferVersion` | `MockDatabase.quotations`, `deals` | `dealProvider`, `negotiationProvider` | Header, NegotiationTab, Dashboard | تم إرسال V2 | تم تقديم عرض جديد |
| **`BusinessChatScreen`** | `NegotiationCardWidget` | قبول العرض | `acceptQuotation` | `MockDatabase.agreements`, `deals` | `dealProvider`, `agreementProvider` | Header, AgreementTab, Dashboard | تم قبول العرض 🟢 | تم توقيع العقد |
| **`BusinessChatScreen`** | `NegotiationCardWidget` | طلب تعديل | `showModificationBottomSheet` | `MockDatabase.quotations` | `dealProvider`, `negotiationProvider` | NegotiationTab, Header | طلب تعديل العرض | طلب تعديل العرض |
| **`BusinessChatScreen`** | `MessageInputWidget` | إرسال رسالة | `sendMessage` | `MockDatabase.messages` | `dealChatProvider` | MessagesTab, ChatList | - | رسالة جديدة |
