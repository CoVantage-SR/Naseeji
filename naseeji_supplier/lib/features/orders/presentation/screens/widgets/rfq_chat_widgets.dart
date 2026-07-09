import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../domain/entities/chat_message.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'مصنع الأقمشة المتطور',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'نشط الآن',
                    style: TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RfqChatInfoBar extends StatelessWidget {
  final String rfqId;

  const RfqChatInfoBar({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8F0FE),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => context.push('/rfq-details?rfqId=$rfqId'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'عرض التفاصيل',
              style: TextStyle(
                color: Color(0xFF0040E0),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'RFQ #$rfqId - Cotton 100%',
            style: const TextStyle(
              color: Color(0xFF0040E0),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String rfqId;

  const ChatMessagesList({super.key, required this.messages, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true, // Show from bottom up
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // Reverse indices to display chronological messages from bottom
        final msg = messages[messages.length - 1 - index];
        return _buildMessageBubble(context, msg);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    if (msg.isTypingIndicator) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAEF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      );
    }

    if (msg.priceUpdateOld != null && msg.priceUpdateNew != null) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0040E0), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F9F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'مراجعة مطلوبة',
                      style: TextStyle(
                        color: Color(0xFF006B5F),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'تحديث عرض السعر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'السعر الجديد',
                              style: TextStyle(fontSize: 10, color: AppColors.outline),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${msg.priceUpdateNew!.toStringAsFixed(2)} ريال/م',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0040E0),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'السعر القديم',
                              style: TextStyle(fontSize: 10, color: AppColors.outline),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${msg.priceUpdateOld!.toStringAsFixed(2)} ريال/م',
                              style: const TextStyle(
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFE2E1EF)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(((msg.priceUpdateOld! - msg.priceUpdateNew!).abs() / msg.priceUpdateOld!) * 100).toStringAsFixed(1)}% توفير للمصنع',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF006B5F), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'الفرق: ${(msg.priceUpdateOld! - msg.priceUpdateNew!).toStringAsFixed(2)} ر.س',
                          style: const TextStyle(fontSize: 10, color: AppColors.outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (msg.priceUpdateDesc != null)
                Text(
                  msg.priceUpdateDesc!,
                  style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.end,
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفض السعر والتصعيد للتعديل')));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text(
                        'رفض',
                        style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.push('/orders/quotation-history?rfqId=$rfqId');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF006B5F)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text(
                        'مراجعة السجل',
                        style: TextStyle(color: Color(0xFF006B5F), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/orders/final-agreement?rfqId=$rfqId'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040E0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'قبول العقد',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (msg.pdfName != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E1EF).withValues(alpha: 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: const Color(0xFFE2E1EF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg.pdfName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (msg.pdfSize != null)
                          Text(
                            msg.pdfSize!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 24),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4, bottom: 12),
              child: Text(
                msg.time,
                style: const TextStyle(fontSize: 9, color: AppColors.outline),
              ),
            ),
          ],
        ),
      );
    }

    if (msg.imageAttachments != null && msg.imageAttachments!.isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: msg.imageAttachments!.map((imgUrl) {
              return Expanded(
                child: Container(
                  height: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    // Default Text Bubble
    return Align(
      alignment: msg.isOutgoing ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: msg.isOutgoing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: msg.isOutgoing ? const Color(0xFF0040E0) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: msg.isOutgoing ? const Radius.circular(0) : const Radius.circular(16),
                bottomRight: msg.isOutgoing ? const Radius.circular(16) : const Radius.circular(0),
              ),
              boxShadow: msg.isOutgoing
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
            ),
            child: Text(
              msg.content,
              style: TextStyle(
                color: msg.isOutgoing ? Colors.white : AppColors.onSurface,
                fontSize: 12,
                height: 1.4,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 12),
            child: Text(
              msg.time,
              style: const TextStyle(fontSize: 9, color: AppColors.outline),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedRepliesBar extends StatelessWidget {
  final List<String> replies;
  final Function(String) onReplyTap;

  const SuggestedRepliesBar({super.key, required this.replies, required this.onReplyTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: replies.map((reply) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => onReplyTap(reply),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E1EF)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reply,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF0040E0),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              onPressed: onSend,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك...',
                    hintStyle: TextStyle(color: AppColors.outline, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
