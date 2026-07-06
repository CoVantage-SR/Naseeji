import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class BusinessChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final List<String> quickReplies;
  final Function(String)? onQuickReply;

  const BusinessChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.quickReplies = const [],
    this.onQuickReply,
  });

  @override
  State<BusinessChatInput> createState() => _BusinessChatInputState();
}

class _BusinessChatInputState extends State<BusinessChatInput> {
  bool _showAttachMenu = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quick replies
        if (widget.quickReplies.isNotEmpty)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: widget.quickReplies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) => ActionChip(
                label: Text(widget.quickReplies[i], style: const TextStyle(fontSize: 11)),
                onPressed: () => widget.onQuickReply?.call(widget.quickReplies[i]),
                backgroundColor: AppColors.surfaceContainerLow,
                side: BorderSide.none,
              ),
            ),
          ),
        if (widget.quickReplies.isNotEmpty) const SizedBox(height: 6),
        // Attach menu popup
        if (_showAttachMenu)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachOption(icon: Icons.image_outlined, label: 'صورة', color: AppColors.primary, onTap: () => setState(() => _showAttachMenu = false)),
                _AttachOption(icon: Icons.videocam_outlined, label: 'فيديو', color: Colors.purple, onTap: () => setState(() => _showAttachMenu = false)),
                _AttachOption(icon: Icons.picture_as_pdf_outlined, label: 'PDF', color: Colors.red, onTap: () => setState(() => _showAttachMenu = false)),
                _AttachOption(icon: Icons.description_outlined, label: 'مستند', color: Colors.blue, onTap: () => setState(() => _showAttachMenu = false)),
                _AttachOption(icon: Icons.location_on_outlined, label: 'موقع', color: Colors.green, onTap: () => setState(() => _showAttachMenu = false)),
                _AttachOption(icon: Icons.mic_outlined, label: 'صوت', color: Colors.orange, onTap: () => setState(() => _showAttachMenu = false)),
              ],
            ),
          ),
        // Input row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.outlineVariant)),
          ),
          child: Row(
            children: [
              // Send button
              Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    if (widget.controller.text.trim().isNotEmpty) widget.onSend();
                  },
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 100),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.outline),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Emoji
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.outline, size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              // Attach
              IconButton(
                icon: Icon(
                  _showAttachMenu ? Icons.close : Icons.attach_file,
                  color: _showAttachMenu ? Colors.red : AppColors.outline,
                  size: 22,
                ),
                onPressed: () => setState(() => _showAttachMenu = !_showAttachMenu),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}
