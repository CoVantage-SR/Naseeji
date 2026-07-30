import '../../domain/entities/employee_entities.dart';
import '../../../account/data/datasources/account_mock_database.dart';
import '../../../account/domain/entities/account_entities.dart' as acc;

class EmployeesMockDatabase {
  EmployeesMockDatabase._();

  static final EmployeesMockDatabase instance = EmployeesMockDatabase._();

  static const Map<String, ModulePermission> _fullPermissions = {
    'لوحة التحكم': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'السوق': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'طلبات الأسعار': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الصفقات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الطلبات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'المنتجات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الموردين': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'المحفظة': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'التحليلات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الموظفين': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الإعدادات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الدعم الفني': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
    'الإشعارات': ModulePermission(view: true, create: true, edit: true, delete: true, approve: true, export: true),
  };

  static const Map<String, ModulePermission> _standardPermissions = {
    'لوحة التحكم': ModulePermission(view: true),
    'السوق': ModulePermission(view: true, create: true),
    'طلبات الأسعار': ModulePermission(view: true, create: true, edit: true),
    'الصفقات': ModulePermission(view: true, edit: true),
    'الطلبات': ModulePermission(view: true),
    'المنتجات': ModulePermission(view: true),
    'الموردين': ModulePermission(view: true),
  };

  List<EmployeeEntity> _employees = [
    // 1. EMP001
    const EmployeeEntity(
      id: 'EMP001',
      name: 'أحمد إبراهيم محمد',
      jobTitle: 'مدير مشتريات',
      department: 'قسم المشتريات',
      role: 'purchasingManager',
      phone: '+20 10 1234 5678',
      email: 'ahmed.ibrahim@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/01/15',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 08:45 ص',
      lastActivity: 'تعديل عرض سعر #RFQ-102',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'مصطفى النجار',
    ),
    // 2. EMP002
    const EmployeeEntity(
      id: 'EMP002',
      name: 'سارة محمد علي',
      jobTitle: 'أخصائي جودة',
      department: 'قسم الجودة',
      role: 'qualityInspector',
      phone: '+20 11 9876 5432',
      email: 'sara.ali@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/03/10',
      employmentType: 'دوام كامل',
      lastLogin: 'أمس 06:30 م',
      lastActivity: 'اعتماد فحص جودة الشحنة #ORD-501',
      permissionsCount: 5,
      permissions: _standardPermissions,
      managerName: 'د. خالد توفيق',
    ),
    // 3. EMP003
    const EmployeeEntity(
      id: 'EMP003',
      name: 'محمود حسن إسماعيل',
      jobTitle: 'مشرف إنتاج',
      department: 'قسم الإنتاج',
      role: 'productionManager',
      phone: '+20 12 4455 6677',
      email: 'mahmoud.hassan@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      status: EmployeeStatus.onLeave,
      joiningDate: '2022/11/01',
      employmentType: 'دوام كامل',
      lastLogin: '2024/06/10 03:20 م',
      lastActivity: 'تقديم طلب إجازة سنوية',
      leaveReturnDate: '2024/06/25',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'مهندس حسام البنا',
    ),
    // 4. EMP004
    const EmployeeEntity(
      id: 'EMP004',
      name: 'نادية أحمد حسن',
      jobTitle: 'محاسب',
      department: 'قسم المالية',
      role: 'accountant',
      phone: '+20 10 3344 5566',
      email: 'nadia.hassan@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/05/20',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 09:15 ص',
      lastActivity: 'تسجبل دفعة بنكية 45,000 ج.م',
      permissionsCount: 5,
      permissions: _standardPermissions,
      managerName: 'أ. طارق الشريف',
    ),
    // 5. EMP005
    const EmployeeEntity(
      id: 'EMP005',
      name: 'يوسف طارق السيد',
      jobTitle: 'فني صيانة',
      department: 'قسم الصيانة',
      role: 'viewer',
      phone: '+20 15 1122 3344',
      email: 'youssef.tarek@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      status: EmployeeStatus.inactive,
      joiningDate: '2024/01/01',
      employmentType: 'عقد',
      lastLogin: 'منذ 15 يوم',
      lastActivity: 'إكمال صيانة ماكينة الغزل #M-04',
      permissionsCount: 2,
      permissions: _standardPermissions,
      managerName: 'مهندس إبراهيم خليل',
    ),
    // 6. EMP006
    const EmployeeEntity(
      id: 'EMP006',
      name: 'عمر خالد الغندور',
      jobTitle: 'مدير مخازن',
      department: 'قسم المخازن',
      role: 'warehouseManager',
      phone: '+20 10 9988 7766',
      email: 'omar.gハンドour@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2022/08/15',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 10:00 ص',
      lastActivity: 'استلام شحنة خيوط بوليستر',
      permissionsCount: 6,
      permissions: _fullPermissions,
      managerName: 'مصطفى النجار',
    ),
    // 7. EMP007
    const EmployeeEntity(
      id: 'EMP007',
      name: 'فاطمة الزهراء علي',
      jobTitle: 'أخصائي مبيعات وتصدير',
      department: 'قسم المبيعات',
      role: 'purchasingOfficer',
      phone: '+20 11 4433 2211',
      email: 'fatma.zahra@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/09/01',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 11:30 ص',
      lastActivity: 'إرسال عرض سعر لعميل دبي',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'أحمد إبراهيم محمد',
    ),
    // 8. EMP008
    const EmployeeEntity(
      id: 'EMP008',
      name: 'مصطفى النجار',
      jobTitle: 'مالك ورئيس التنفيذي',
      department: 'الإدارة العليا',
      role: 'owner',
      phone: '+20 10 0000 1111',
      email: 'mostafa.nagar@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2020/01/01',
      employmentType: 'دوام كامل',
      lastLogin: 'منذ 5 دقائق',
      lastActivity: 'الموافقة على ميزانية الربع الثالث',
      permissionsCount: 13,
      permissions: _fullPermissions,
      managerName: 'مجلس الإدارة',
    ),
    // 9. EMP009
    const EmployeeEntity(
      id: 'EMP009',
      name: 'هبة رجب الجارحي',
      jobTitle: 'مسؤول الموارد البشرية',
      department: 'الإدارة العليا',
      role: 'admin',
      phone: '+20 12 7766 5544',
      email: 'heba.ragab@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/02/10',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 08:00 ص',
      lastActivity: 'إضافة الموظف EMP024',
      permissionsCount: 8,
      permissions: _fullPermissions,
      managerName: 'مصطفى النجار',
    ),
    // 10. EMP010
    const EmployeeEntity(
      id: 'EMP010',
      name: 'كريم عبدالمجيد',
      jobTitle: 'مهندس صيانة تشغيلية',
      department: 'قسم الصيانة',
      role: 'viewer',
      phone: '+20 10 6655 4433',
      email: 'kareem.abdo@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/11/15',
      employmentType: 'دوام كامل',
      lastLogin: 'أمس 04:15 م',
      lastActivity: 'فحص دوري لخط الصباغة',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'يوسف طارق السيد',
    ),
    // 11. EMP011
    const EmployeeEntity(
      id: 'EMP011',
      name: 'منى الشاذلي',
      jobTitle: 'أخصائي مشتريات خامات',
      department: 'قسم المشتريات',
      role: 'purchasingOfficer',
      phone: '+20 11 8877 6655',
      email: 'mona.shazly@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2024/02/01',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 10:45 ص',
      lastActivity: 'إنشاء RFQ جديد للغزول قطن 100%',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'أحمد إبراهيم محمد',
    ),
    // 12. EMP012
    const EmployeeEntity(
      id: 'EMP012',
      name: 'طارق العريان',
      jobTitle: 'مدير قطاع الإنتاج',
      department: 'قسم الإنتاج',
      role: 'productionManager',
      phone: '+20 10 1122 9988',
      email: 'tarek.arian@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2021/05/10',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 07:30 ص',
      lastActivity: 'تحديث خطة الإنتاج اليومية',
      permissionsCount: 6,
      permissions: _fullPermissions,
      managerName: 'مصطفى النجار',
    ),
    // 13. EMP013
    const EmployeeEntity(
      id: 'EMP013',
      name: 'سمر فتحي عبدالرازق',
      jobTitle: 'أمينة مخزن قطع الغيار',
      department: 'قسم المخازن',
      role: 'logistics',
      phone: '+20 12 3322 1100',
      email: 'samar.fathi@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/07/20',
      employmentType: 'دوام كامل',
      lastLogin: 'أمس 02:00 م',
      lastActivity: 'جرد مخزني شهر يوليو',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'عمر خالد الغندور',
    ),
    // 14. EMP014
    const EmployeeEntity(
      id: 'EMP014',
      name: 'وليد توفيق الحكيم',
      jobTitle: 'سائق شاحنة توريد',
      department: 'قسم المخازن',
      role: 'logistics',
      phone: '+20 15 9900 1122',
      email: 'waleed.tawfik@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      status: EmployeeStatus.onLeave,
      joiningDate: '2022/04/12',
      employmentType: 'عقد',
      lastLogin: '2024/06/15 11:00 ص',
      lastActivity: 'تسليم طلبية الإسكندرية',
      leaveReturnDate: '2024/07/01',
      permissionsCount: 2,
      permissions: _standardPermissions,
      managerName: 'عمر خالد الغندور',
    ),
    // 15. EMP015
    const EmployeeEntity(
      id: 'EMP015',
      name: 'رانيا يوسف فهمي',
      jobTitle: 'محلل بيانات مالية',
      department: 'قسم المالية',
      role: 'accountant',
      phone: '+20 11 5544 3322',
      email: 'rania.youssef@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/10/05',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 09:00 ص',
      lastActivity: 'استخراج تقرير التكاليف والمبيعات',
      permissionsCount: 5,
      permissions: _standardPermissions,
      managerName: 'نادية أحمد حسن',
    ),
    // 16. EMP016
    const EmployeeEntity(
      id: 'EMP016',
      name: 'زياد طارق الخولي',
      jobTitle: 'فني غزل ونسيج',
      department: 'قسم الإنتاج',
      role: 'viewer',
      phone: '+20 10 4411 2233',
      email: 'ziad.tarek@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2024/03/15',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 06:45 ص',
      lastActivity: 'بداية وردية الصباح',
      permissionsCount: 2,
      permissions: _standardPermissions,
      managerName: 'محمود حسن إسماعيل',
    ),
    // 17. EMP017
    const EmployeeEntity(
      id: 'EMP017',
      name: 'داليا مصطفى عامر',
      jobTitle: 'مفتش جودة خامات',
      department: 'قسم الجودة',
      role: 'qualityInspector',
      phone: '+20 12 8899 0011',
      email: 'dalia.amer@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/06/01',
      employmentType: 'دوام كامل',
      lastLogin: 'أمس 01:15 م',
      lastActivity: 'فحص معملي لدرجة متانة الخيوط',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'سارة محمد علي',
    ),
    // 18. EMP018
    const EmployeeEntity(
      id: 'EMP018',
      name: 'خالد إبراهيم رزق',
      jobTitle: 'مترجم ومسؤول العلاقات الدولية',
      department: 'الإدارة العليا',
      role: 'purchasingOfficer',
      phone: '+20 10 7711 2244',
      email: 'khaled.rezk@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      status: EmployeeStatus.inactive,
      joiningDate: '2023/04/01',
      employmentType: 'عن بُعد',
      lastLogin: 'منذ 20 يوم',
      lastActivity: 'ترجمة الكتالوج الفني إلى الإنجليزية',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'مصطفى النجار',
    ),
    // 19. EMP019
    const EmployeeEntity(
      id: 'EMP019',
      name: 'نهى سمير الباز',
      jobTitle: 'خدمة عملاء ودعم فني',
      department: 'قسم المبيعات',
      role: 'viewer',
      phone: '+20 11 2233 4455',
      email: 'noha.sameer@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1548142813-c348350df52b?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2024/01/10',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 12:00 م',
      lastActivity: 'الرد على تذكرة دعم رقم TCK-8801',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'فاطمة الزهراء علي',
    ),
    // 20. EMP020
    const EmployeeEntity(
      id: 'EMP020',
      name: 'أيمن صلاح العفيفي',
      jobTitle: 'مشرف أمن وحراسة',
      department: 'الإدارة العليا',
      role: 'viewer',
      phone: '+20 15 3344 5566',
      email: 'ayman.afifi@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2022/02/01',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 06:00 ص',
      lastActivity: 'تسليم وردية الأمن الليلية',
      permissionsCount: 2,
      permissions: _standardPermissions,
      managerName: 'هبة رجب الجارحي',
    ),
    // 21. EMP021
    const EmployeeEntity(
      id: 'EMP021',
      name: 'أميرة جلال عبيد',
      jobTitle: 'أخصائي تصميم وتطوير عينات',
      department: 'قسم الإنتاج',
      role: 'viewer',
      phone: '+20 10 9900 8877',
      email: 'amira.galal@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2023/12/01',
      employmentType: 'دوام جزئي',
      lastLogin: 'أمس 03:00 م',
      lastActivity: 'تجهيز نموذج عينة قماش صيفي',
      permissionsCount: 3,
      permissions: _standardPermissions,
      managerName: 'طارق العريان',
    ),
    // 22. EMP022
    const EmployeeEntity(
      id: 'EMP022',
      name: 'حسن حلمي عبدالباقي',
      jobTitle: 'مشرف غلايات ومحطة طاقة',
      department: 'قسم الصيانة',
      role: 'viewer',
      phone: '+20 12 1199 2288',
      email: 'hassan.helmy@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2021/09/15',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 07:00 ص',
      lastActivity: 'اختبار قياس ضغط البخار',
      permissionsCount: 2,
      permissions: _standardPermissions,
      managerName: 'كريم عبدالمجيد',
    ),
    // 23. EMP023
    const EmployeeEntity(
      id: 'EMP023',
      name: 'ريم أحمد الشناوي',
      jobTitle: 'مساعد محاسب',
      department: 'قسم المالية',
      role: 'accountant',
      phone: '+20 11 6677 8899',
      email: 'reem.shennawy@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2024/04/01',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 11:00 ص',
      lastActivity: 'مراجعة فواتير التوريد الشهرية',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'نادية أحمد حسن',
    ),
    // 24. EMP024
    const EmployeeEntity(
      id: 'EMP024',
      name: 'تامر سعد الدين',
      jobTitle: 'أخصائي سلامة وصحة مهنية',
      department: 'قسم الجودة',
      role: 'qualityInspector',
      phone: '+20 10 5566 7788',
      email: 'tamer.saad@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      status: EmployeeStatus.active,
      joiningDate: '2024/05/15',
      employmentType: 'دوام كامل',
      lastLogin: 'اليوم 09:30 ص',
      lastActivity: 'جولة تفقدية لمعدات السلامة والحرائق',
      permissionsCount: 4,
      permissions: _standardPermissions,
      managerName: 'سارة محمد علي',
    ),
  ];

  List<DepartmentEntity> _departments = [
    const DepartmentEntity(id: 'DEP-01', name: 'قسم المشتريات', code: 'PURCHASING', description: 'مسؤول عن شراء الخامات والمستلزمات', headName: 'أحمد إبراهيم محمد', employeeCount: 3, iconName: 'shopping_bag'),
    const DepartmentEntity(id: 'DEP-02', name: 'قسم الإنتاج', code: 'PRODUCTION', description: 'مسؤول عن عمليات الغزل والنسيج والتصنيع', headName: 'طارق العريان', employeeCount: 5, iconName: 'factory'),
    const DepartmentEntity(id: 'DEP-03', name: 'قسم المالية', code: 'FINANCE', description: 'مسؤول عن الحسابات والميزانيات والفواتير', headName: 'نادية أحمد حسن', employeeCount: 3, iconName: 'account_balance_wallet'),
    const DepartmentEntity(id: 'DEP-04', name: 'قسم المخازن', code: 'WAREHOUSE', description: 'إدارة المخزون واستلام المواد والشحن', headName: 'عمر خالد الغندور', employeeCount: 3, iconName: 'inventory_2'),
    const DepartmentEntity(id: 'DEP-05', name: 'قسم الجودة', code: 'QUALITY', description: 'مراقبة وفحص جودة الخامات والمنتجات النهائي', headName: 'سارة محمد علي', employeeCount: 3, iconName: 'verified'),
    const DepartmentEntity(id: 'DEP-06', name: 'قسم الصيانة', code: 'MAINTENANCE', description: 'صيانة ماكينات الغزل والمعدات الصناعية', headName: 'يوسف طارق السيد', employeeCount: 3, iconName: 'build'),
    const DepartmentEntity(id: 'DEP-07', name: 'الإدارة العليا', code: 'ADMINISTRATION', description: 'الإدارة العامة والموارد البشرية والشؤون القانونية', headName: 'مصطفى النجار', employeeCount: 4, iconName: 'business'),
    const DepartmentEntity(id: 'DEP-08', name: 'قسم المبيعات', code: 'SALES', description: 'التسويق والمبيعات المحلية والتصدير الدولي', headName: 'فاطمة الزهراء علي', employeeCount: 2, iconName: 'sell'),
  ];

  List<RoleEntity> _roles = [
    const RoleEntity(id: 'ROL-01', name: 'مالك المصنع', code: 'owner', description: 'صلاحيات كاملة وغير محدودة على كل النظام', assignedUsersCount: 2, permissions: _fullPermissions),
    const RoleEntity(id: 'ROL-02', name: 'مدير النظام', code: 'admin', description: 'إدارة الموظفين والإعدادات والصلاحيات', assignedUsersCount: 2, permissions: _fullPermissions),
    const RoleEntity(id: 'ROL-03', name: 'مدير المشتريات', code: 'purchasingManager', description: 'إنشاء واعتماد طلبات الأسعار والعروض والصفقات', assignedUsersCount: 2, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-04', name: 'مسؤول مشتريات', code: 'purchasingOfficer', description: 'متابعة الموردين وإنشاء طلبات عروض الأسعار', assignedUsersCount: 3, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-05', name: 'مدير المخزن', code: 'warehouseManager', description: 'إدارة مخزون الغزول والأقمشة وطلبات الشحن', assignedUsersCount: 2, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-06', name: 'محاسب / مالية', code: 'accountant', description: 'إدارة الفواتير والتحويلات المالية والمحفظة', assignedUsersCount: 3, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-07', name: 'مدير الإنتاج', code: 'productionManager', description: 'متابعة خطط الإنتاج وطلبات التصنيع', assignedUsersCount: 2, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-08', name: 'مسؤول جودة', code: 'qualityInspector', description: 'فحص المنتجات وتوثيق اختبارات الجودة', assignedUsersCount: 3, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-09', name: 'مسؤول لوجستيات', code: 'logistics', description: 'إدارة وتنسيق عملية الشحن والتوصيل', assignedUsersCount: 2, permissions: _standardPermissions),
    const RoleEntity(id: 'ROL-10', name: 'مشاهد فقط', code: 'viewer', description: 'عرض البيانات والتقارير دون إمكانية التعديل', assignedUsersCount: 4, permissions: _standardPermissions),
  ];

  // Getters
  List<EmployeeEntity> get employees => List.unmodifiable(_employees);
  List<DepartmentEntity> get departments => List.unmodifiable(_departments);
  List<RoleEntity> get roles => List.unmodifiable(_roles);

  // Mutations & Sync
  void addEmployee(EmployeeEntity emp) {
    _employees = [emp, ..._employees];
    // Sync with AccountMockDatabase
    AccountMockDatabase.instance.addEmployee(
      EmployeeEntityToAccountMapper.toAccountEntity(emp),
    );
  }

  void updateEmployee(EmployeeEntity updated) {
    _employees = _employees.map((e) => e.id == updated.id ? updated : e).toList();
    AccountMockDatabase.instance.updateEmployee(
      EmployeeEntityToAccountMapper.toAccountEntity(updated),
    );
  }

  void deleteEmployee(String id) {
    _employees = _employees.where((e) => e.id != id).toList();
    AccountMockDatabase.instance.removeEmployee(id);
  }

  void suspendEmployee(String id, String reason) {
    _employees = _employees.map((e) {
      if (e.id == id) {
        return e.copyWith(
          status: EmployeeStatus.suspended,
          suspensionReason: reason,
        );
      }
      return e;
    }).toList();
  }

  void addDepartment(DepartmentEntity dept) {
    _departments = [dept, ..._departments];
  }

  void addRole(RoleEntity role) {
    _roles = [role, ..._roles];
  }
}

/// Mapper to keep AccountMockDatabase in sync
class EmployeeEntityToAccountMapper {
  static acc.EmployeeEntity toAccountEntity(EmployeeEntity emp) {
    return acc.EmployeeEntity(
      id: emp.id,
      name: emp.name,
      jobTitle: emp.jobTitle,
      phone: emp.phone,
      email: emp.email,
      photoUrl: emp.photoUrl,
      role: emp.role,
      status: emp.status.code,
      department: emp.department,
      lastLogin: emp.lastLogin,
      permissions: {
        for (final entry in emp.permissions.entries)
          entry.key: entry.value.view,
      },
    );
  }
}
