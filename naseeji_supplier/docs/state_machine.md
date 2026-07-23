# ⚙️ وثيقة آلة الحالات (State Machine & Transition Rules)
## تطبيق نسيجي للموردين — NASEEJI Supplier App

---

## 📌 جدول الحالات والانتقالات المسموحة والممنوعة (24 System States)

| الحالة الحالية | الحالات المسموح الانتقال إليها | الحالات الممنوعة |
| :--- | :--- | :--- |
| `Draft` | `RFQ Received`, `Negotiating`, `Cancelled` | `Agreed`, `Completed`, `In Production` |
| `RFQ Received` | `Negotiating`, `Awaiting Response`, `Cancelled` | `Completed`, `Delivered` |
| `Negotiating` | `Awaiting Response`, `Counter Offer`, `Agreed`, `Rejected`, `Cancelled` | `Completed`, `Delivered` |
| `Awaiting Response` | `Agreed`, `Counter Offer`, `Rejected`, `Expired` | `Completed`, `In Production` |
| `Counter Offer` | `Awaiting Response`, `Agreed`, `Rejected`, `Cancelled` | `Completed` |
| `Offer Accepted` / `Agreed` | `Agreement Pending`, `Agreement Signed`, `In Production` | `Negotiating`, `Draft` |
| `Agreement Signed` | `In Production`, `Cancelled` | `Negotiating`, `Draft` |
| `In Production` | `Ready For Delivery`, `Issue Reported`, `On Hold` | `Negotiating`, `Draft` |
| `Ready For Delivery` | `Delivering`, `On Hold` | `Draft`, `Negotiating` |
| `Delivering` | `Delivered`, `Issue Reported` | `Draft`, `Negotiating` |
| `Delivered` | `Quality Inspection`, `Quality Approved`, `Quality Rejected` | `In Production` |
| `Quality Inspection` | `Quality Approved`, `Quality Rejected` | `In Production` |
| `Quality Approved` | `Payment Pending`, `Completed` | `Draft` |
| `Payment Pending` | `Completed`, `Issue Reported` | `Draft` |
| `Completed` | `Closed` | جميع الحالات السابقة |
| `Cancelled` / `Rejected` / `Expired` | `Closed` | جميع الحالات النشطة |
