// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/messages/presentation/controllers/deal_workspace_controller.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/header/conversation_header_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/messages_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/quotation_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/agreement_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/files_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/timeline_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/input/message_input_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/moderation_warning_dialog.dart';

class BusinessChatScreen extends ConsumerStatefulWidget {
  final String dealId;
  final String? conversationId;

  BusinessChatScreen({
    super.key,
    String? dealId,
    String? conversationId,
  })  : dealId = dealId ?? conversationId ?? 'deal-101',
        conversationId = conversationId ?? dealId;

  @override
  ConsumerState<BusinessChatScreen> createState() => _BusinessChatScreenState();
}

class _BusinessChatScreenState extends ConsumerState<BusinessChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(dealWorkspaceControllerProvider(widget.dealId).notifier).setActiveTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCounterOfferBottomSheet(BuildContext context) {
    final qtyController = TextEditingController(text: '1000');
    final priceController = TextEditingController(text: '43');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إنشاء عرض سعر مضاد للمصنع',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('أدخل السعر والكمية المقترحة للتفاوض على هذه الصفقة:', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 14),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'سعر الوحدة المقترح (بالجنيه)',
                hintText: '43',
                prefixIcon: Icon(Icons.sell_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الكمية المطلوبة',
                hintText: '1000',
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final p = double.tryParse(priceController.text) ?? 43.0;
                  final q = int.tryParse(qtyController.text) ?? 1000;
                  ref.read(dealWorkspaceControllerProvider(widget.dealId).notifier).submitCounterOffer(p, q);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال عرض السعر المضاد بنجاح!')),
                  );
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('إرسال العرض المضاد'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetailsBottomSheet(BuildContext context, dynamic workspace) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الطلب (${workspace.orderId})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('• المصنع: ${workspace.factoryName}'),
            const SizedBox(height: 6),
            Text('• رقم الطلب: ${workspace.orderId}'),
            const SizedBox(height: 6),
            Text('• رقم RFQ: ${workspace.rfqId}'),
            const SizedBox(height: 6),
            Text('• حالة الصفقة: ${workspace.currentStatus.arabicLabel}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dealWorkspaceControllerProvider(widget.dealId));
    final controller = ref.read(dealWorkspaceControllerProvider(widget.dealId).notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.listen<DealWorkspaceState>(dealWorkspaceControllerProvider(widget.dealId), (previous, next) {
      if (next.moderationResult.isProhibited) {
        showDialog(
          context: context,
          builder: (context) => ModerationWarningDialog(
            matchedReason: next.moderationResult.reason,
          ),
        ).then((_) => controller.clearModerationWarning());
      }
    });

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null || state.workspace == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('مساحة الصفقة')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
              const SizedBox(height: 12),
              Text(state.errorMessage ?? 'تعذر تحميل الصفقة'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => controller.loadWorkspace(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    final workspace = state.workspace!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مساحة عمل إدارة الصفقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            ConversationHeaderWidget(workspace: workspace),

            Container(
              color: colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: '1. المحادثة'),
                  Tab(text: '2. عرض السعر'),
                  Tab(text: '3. الاتفاق'),
                  Tab(text: '4. الملفات'),
                  Tab(text: '5. الخط الزمني'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MessagesTabWidget(messages: workspace.messages),
                  QuotationTabWidget(
                    quotation: workspace.latestQuotation,
                    onAccept: () => controller.acceptQuotation(),
                    onReject: () => controller.rejectQuotation(),
                    onCounterOffer: () => _showCounterOfferBottomSheet(context),
                  ),
                  AgreementTabWidget(agreement: workspace.finalAgreement),
                  FilesTabWidget(files: workspace.files),
                  TimelineTabWidget(timeline: workspace.timeline),
                ],
              ),
            ),

            MessageInputWidget(
              onSendMessage: (text) => controller.sendMessage(text),
              onSendAttachment: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اختيار ملف أو صورة لإرفاقها في المحادثة')),
                );
              },
              onCreateCounterOffer: () => _showCounterOfferBottomSheet(context),
              onViewOrderDetails: () => _showOrderDetailsBottomSheet(context, workspace),
            ),
          ],
        ),
      ),
    );
  }
}