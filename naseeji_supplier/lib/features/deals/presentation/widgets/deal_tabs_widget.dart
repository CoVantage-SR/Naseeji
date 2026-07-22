import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/deals/domain/entities/deal_model.dart';
import 'tabs/deal_info_widget.dart';
import 'tabs/quotation_widget.dart';
import 'tabs/negotiation_widget.dart';
import 'tabs/agreement_widget.dart';
import 'tabs/production_widget.dart';
import 'tabs/delivery_widget.dart';
import 'tabs/quality_widget.dart';
import 'tabs/payment_widget.dart';
import 'tabs/timeline_widget.dart';
import 'tabs/deal_files_widget.dart';

class DealTabsWidget extends StatefulWidget {
  final DealModel deal;

  const DealTabsWidget({super.key, required this.deal});

  @override
  State<DealTabsWidget> createState() => _DealTabsWidgetState();
}

class _DealTabsWidgetState extends State<DealTabsWidget> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Horizontal Scrollable Tab Bar
        Container(
          color: colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'معلومات'),
              Tab(text: 'عرض السعر'),
              Tab(text: 'التفاوض'),
              Tab(text: 'الاتفاق'),
              Tab(text: 'الإنتاج'),
              Tab(text: 'التسليم'),
              Tab(text: 'الجودة'),
              Tab(text: 'الدفع'),
              Tab(text: 'Timeline'),
              Tab(text: 'الملفات'),
            ],
          ),
        ),

        // Tab View Body
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              DealInfoWidget(deal: widget.deal),
              QuotationWidget(deal: widget.deal),
              NegotiationWidget(deal: widget.deal),
              AgreementWidget(deal: widget.deal),
              ProductionWidget(deal: widget.deal),
              DeliveryWidget(deal: widget.deal),
              QualityWidget(deal: widget.deal),
              PaymentWidget(deal: widget.deal),
              TimelineWidget(deal: widget.deal),
              DealFilesWidget(deal: widget.deal),
            ],
          ),
        ),
      ],
    );
  }
}
