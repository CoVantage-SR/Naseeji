# 🗺️ خريطة وشجرة التنقل داخل التطبيق (Navigation Flow Documentation)
## تطبيق نسيجي للموردين — NASEEJI Supplier App

---

## 📌 مخطط التنقل الرئيسي وشريط التصفح (Bottom Navigation Architecture)

```mermaid
graph TD
    Root["AppShell / GoRouter"] --> Tab1["🏠 1. الرئيسية (Dashboard)"]
    Root --> Tab2["📦 2. المنتجات (Products)"]
    Root --> Tab3["💬 3. المحادثات (Messages List)"]
    Root --> Tab4["🤝 4. الصفقات (Deals List)"]
    Root --> Tab5["👤 5. الحساب (Profile)"]

    Tab3 --> ChatScreen["Deal Workspace Screen (/messages/chat)"]
    Tab4 --> ChatScreen
    Tab1 --> ChatScreen

    ChatScreen --> SubTab1["💬 Messages Tab"]
    ChatScreen --> SubTab2["🤝 Negotiation Tab"]
    ChatScreen --> SubTab3["📄 Agreement Tab"]
    ChatScreen --> SubTab4["📁 Files Tab"]
    ChatScreen --> SubTab5["📍 Timeline Tab"]
```

---

## 🗺️ مسارات التنقل بالتفصيل (Route Map)

1. `/dashboard` ⬅️ شاشة الرئيسية والإحصائيات والصفقات النشطة.
2. `/products` ⬅️ قائمة منتجات المورد وخامات القطن والنسيج.
3. `/messages` ⬅️ قائمة المحادثات النشطة المرتبطة بالصفقات.
4. `/messages/chat?dealId=DEAL-101` ⬅️ شاشة التفاوض والشات الموحدة.
5. `/deals` ⬅️ شاشة الصفقات الحالية والمكتملة والمعلقة.
6. `/profile` ⬅️ بيانات المورد والاشتراك والتأكيد والأمان.
