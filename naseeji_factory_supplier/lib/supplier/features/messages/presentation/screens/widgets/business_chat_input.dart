// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class BusinessChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final List<String> quickReplies;
  final Function(String)? onQuickReply;
  final bool isBlocked;

  const BusinessChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.quickReplies = const [],
    this.onQuickReply,
    this.isBlocked = false,
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
        if (widget.quickReplies.isNotEmpty && !widget.isBlocked)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: widget.quickReplies.length,
              separatorBuilder: (_, __) => SizedBox(width: 6),
              itemBuilder: (_, i) => ActionChip(
                label: Text(widget.quickReplies[i], style: TextStyle(fontSize: 11)),
                onPressed: () => widget.onQuickReply?.call(widget.quickReplies[i]),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                side: BorderSide.none,
              ),
            ),
          ),
        if (widget.quickReplies.isNotEmpty && !widget.isBlocked) SizedBox(height: 6),
        // Attach menu popup
        if (_showAttachMenu && !widget.isBlocked)
          Container(
            color: Theme.of(context).colorScheme.surface,
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
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Send button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Material(
                  color: widget.isBlocked ? AppColors.outline : AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: widget.isBlocked
                        ? null
                        : () {
                            if (widget.controller.text.trim().isNotEmpty) widget.onSend();
                          },
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.surface, size: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: TextField(
                    controller: widget.controller,
                    enabled: !widget.isBlocked,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: widget.isBlocked ? 'المحادثة مغلقة بسبب الحظر' : 'اكتب رسالتك هنا...',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.outline),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    ),
                  ),
                ),
              ),
              // Attach
              IconButton(
                icon: Icon(
                  _showAttachMenu && !widget.isBlocked ? Icons.close_rounded : Icons.add_circle_outline_rounded,
                  color: _showAttachMenu && !widget.isBlocked ? Colors.red : AppColors.outline,
                  size: 26,
                ),
                onPressed: widget.isBlocked
                    ? null
                    : () => setState(() => _showAttachMenu = !_showAttachMenu),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              // Emoji
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.outline, size: 24),
                onPressed: widget.isBlocked ? null : () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
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
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}



