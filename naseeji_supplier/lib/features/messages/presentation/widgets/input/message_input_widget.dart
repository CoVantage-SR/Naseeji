import 'package:flutter/material.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(String text) onSendMessage;
  final VoidCallback onSendAttachment;
  final VoidCallback onCreateCounterOffer;
  final VoidCallback onViewOrderDetails;

  const MessageInputWidget({
    super.key,
    required this.onSendMessage,
    required this.onSendAttachment,
    required this.onCreateCounterOffer,
    required this.onViewOrderDetails,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final txt = _textController.text.trim();
    if (txt.isNotEmpty) {
      widget.onSendMessage(txt);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick Actions Shortcut Bar (إنشاء عرض مضاد | عرض تفاصيل الطلب)
            Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.handshake_outlined, size: 14),
                  label: const Text('إنشاء عرض مضاد'),
                  labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.primary),
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
                  onPressed: widget.onCreateCounterOffer,
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.receipt_long_outlined, size: 14),
                  label: const Text('عرض تفاصيل الطلب'),
                  labelStyle: TextStyle(fontSize: 10, color: colorScheme.onSurface),
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  onPressed: widget.onViewOrderDetails,
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Message Input Row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded),
                  tooltip: 'إرفاق ملف أو صورة',
                  onPressed: widget.onSendAttachment,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _handleSend(),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك هنا للمصنع...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: _handleSend,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
