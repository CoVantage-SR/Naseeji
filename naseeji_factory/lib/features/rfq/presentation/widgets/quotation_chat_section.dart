import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Direct B2B Negotiation Chat Section positioned below business & ERP information
class QuotationChatSection extends StatefulWidget {
  final Quotation quotation;

  const QuotationChatSection({super.key, required this.quotation});

  @override
  State<QuotationChatSection> createState() => _QuotationChatSectionState();
}

class _QuotationChatSectionState extends State<QuotationChatSection> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg_1',
      'isSystem': true,
      'text': 'تم تقديم عرض السعر الأصلي بواسطة المورد',
      'time': '10 مايو 2024 - 10:30 ص',
    },
    {
      'id': 'msg_2',
      'isSystem': false,
      'isMe': false,
      'sender': 'م/ أسامة (المورد)',
      'text': 'مرحباً، يسعدنا تلبية طلبكم بخصوص الأقمشة القطنية 100%. أرفقنا العينة والشهادات المعايير.',
      'time': '10 مايو 2024 - 10:35 ص',
      'seen': true,
    },
    {
      'id': 'msg_3',
      'isSystem': false,
      'isMe': true,
      'sender': 'إدارة المشتريات (المصنع)',
      'text': 'أهلاً بكم. هل يمكن مراجعة السعر للوحدة في حالة زيادة الكمية إلى 15,000 متر؟',
      'time': '11 مايو 2024 - 02:15 م',
      'seen': true,
    },
    {
      'id': 'msg_4',
      'isSystem': true,
      'text': 'تم تقديم عرض مقابل بسعر 35.00 ج.م للوحدة',
      'time': '12 مايو 2024 - 09:15 ص',
    },
    {
      'id': 'msg_5',
      'isSystem': false,
      'isMe': false,
      'sender': 'م/ أسامة (المورد)',
      'text': 'تمت الموافقة على تخفيض السعر إلى 37.50 ج.م مع التسليم السريع خلال 7 أيام.',
      'time': '12 مايو 2024 - 11:20 ص',
      'seen': true,
    },
  ];

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
          'isSystem': false,
          'isMe': true,
          'sender': 'أنت (المشتري)',
          'text': text,
          'time': 'الآن',
          'seen': false,
        });
      });
      _msgController.clear();
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.forum_outlined, size: 20, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'المحادثة المباشرة وسجل التواصل',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.success),
                    SizedBox(width: 4),
                    Text('متصل الآن', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Messages List Box
          Container(
            padding: const EdgeInsets.all(12),
            height: 260,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.rSM,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];

                // 1. System Message Banner
                if (msg['isSystem'] == true) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        '⚡ ${msg['text']}',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ),
                  );
                }

                // 2. Chat Bubble
                final isMe = msg['isMe'] == true;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 260,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? primaryColor
                          : (isDark ? const Color(0xFF334155) : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['sender'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          msg['text'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg['time'] as String,
                              style: TextStyle(
                                fontSize: 8,
                                color: isMe ? Colors.white60 : Colors.grey.shade500,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              Icon(
                                msg['seen'] == true ? Icons.done_all_rounded : Icons.done_rounded,
                                size: 12,
                                color: Colors.white70,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Message Input Field
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_rounded, color: Colors.grey, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('إرفاق ملف أو صفقات بالدردشة...')),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: InputDecoration(
                    hintText: 'اكتب استفساراً أو ملحوظة للمورد...',
                    hintStyle: const TextStyle(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: _sendMessage,
                borderRadius: AppRadius.rSM,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: AppRadius.rSM,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
