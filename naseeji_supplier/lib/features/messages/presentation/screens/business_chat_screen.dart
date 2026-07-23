import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/messages/presentation/controllers/deal_workspace_controller.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/header/conversation_header_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/messages_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/negotiation_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/agreement_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/files_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/timeline_tab_widget.dart';
import 'package:naseeji_supplier/features/messages/presentation/widgets/tabs/request_modification_bottom_sheet.dart';
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

  void _showModificationBottomSheet(BuildContext context) {
    final state = ref.read(dealWorkspaceControllerProvider(widget.dealId));
    if (state.workspace == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RequestModificationBottomSheet(
        currentQuotation: state.workspace!.latestQuotation,
        onSubmitNewVersion: ({
          required double unitPrice,
          required int quantity,
          required String productionLeadTime,
          required String validityPeriod,
          required String paymentTerms,
          required String deliveryTerms,
          DateTime? expectedDeliveryDate,
          String? notes,
        }) {
          ref.read(dealWorkspaceControllerProvider(widget.dealId).notifier).submitNewOfferVersion(
                unitPrice: unitPrice,
                quantity: quantity,
                productionLeadTime: productionLeadTime,
                validityPeriod: validityPeriod,
                paymentTerms: paymentTerms,
                deliveryTerms: deliveryTerms,
                expectedDeliveryDate: expectedDeliveryDate,
                notes: notes,
              );
        },
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
              'تفاصيل الصفقة والطلب (${workspace.orderId})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('• المصنع: ${workspace.factoryName}'),
            const SizedBox(height: 6),
            Text('• الخامة: ${workspace.productName}'),
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
                child: const Text('إغلاق التفاصيل'),
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
          title: Text(
            'مساحة صفقة: ${workspace.dealId}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            // Sticky Header
            ConversationHeaderWidget(
              workspace: workspace,
              onViewDealDetails: () => _showOrderDetailsBottomSheet(context, workspace),
              onViewProduct: () => context.push('/products'),
              onViewAgreement: () => _tabController.animateTo(2),
              onViewFiles: () => _tabController.animateTo(3),
              onDownloadPdf: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تجهيز وتحميل مستندات الصفقة بصيغة PDF 📄')),
                );
              },
            ),

            // Tab Bar
            Container(
              color: colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: '💬 الرسائل'),
                  Tab(text: '🤝 التفاوض'),
                  Tab(text: '📄 الاتفاق'),
                  Tab(text: '📁 الملفات'),
                  Tab(text: '📍 Timeline'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MessagesTabWidget(messages: workspace.messages),
                  NegotiationTabWidget(
                    latestQuotation: workspace.latestQuotation,
                    quotationHistory: workspace.quotationHistory,
                    onAccept: () => controller.acceptQuotation(),
                    onReject: () => controller.rejectQuotation(),
                    onSubmitNewVersion: ({
                      required double unitPrice,
                      required int quantity,
                      required String productionLeadTime,
                      required String validityPeriod,
                      required String paymentTerms,
                      required String deliveryTerms,
                      DateTime? expectedDeliveryDate,
                      String? notes,
                    }) {
                      controller.submitNewOfferVersion(
                        unitPrice: unitPrice,
                        quantity: quantity,
                        productionLeadTime: productionLeadTime,
                        validityPeriod: validityPeriod,
                        paymentTerms: paymentTerms,
                        deliveryTerms: deliveryTerms,
                        expectedDeliveryDate: expectedDeliveryDate,
                        notes: notes,
                      );
                    },
                  ),
                  AgreementTabWidget(agreement: workspace.finalAgreement),
                  FilesTabWidget(files: workspace.files),
                  TimelineTabWidget(timeline: workspace.timeline),
                ],
              ),
            ),

            // Message Input Widget
            MessageInputWidget(
              onSendMessage: (text) => controller.sendMessage(text),
              onSendAttachment: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اختيار ملف أو صورة لإرفاقها في المحادثة')),
                );
              },
              onCreateCounterOffer: () => _showModificationBottomSheet(context),
              onViewOrderDetails: () => _showOrderDetailsBottomSheet(context, workspace),
            ),
          ],
        ),
      ),
    );
  }
}