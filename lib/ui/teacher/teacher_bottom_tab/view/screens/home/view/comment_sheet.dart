import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../core/widget/profile_avatar.dart';
import '../controller/teacher_home_controller.dart';
import '../model/post_list/post_list_response.dart';

// ══════════════════════════════════════════════════════════════
//  CommentSheet  –  fully reactive, Instagram-style bottom sheet
//  Uses Obx so every addComment / editComment / deleteComment
//  call instantly updates the list without closing the sheet.
// ══════════════════════════════════════════════════════════════
class CommentSheet extends StatefulWidget {
  final String postId;
  final TeacherHomeController controller;

  const CommentSheet({
    super.key,
    required this.postId,
    required this.controller,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _txtCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  String? _editingCommentId;
  bool _sending = false;

  // ── Theme helpers ─────────────────────────────────────────
  bool get _light => Theme.of(context).brightness == Brightness.light;
  Color get _bg => _light ? Colors.white : const Color(0xFF1C1C1C);
  Color get _textPrimary => _light ? const Color(0xFF111111) : Colors.white;
  Color get _textSecondary =>
      _light ? const Color(0xFF737373) : const Color(0xFF8E8E8E);
  Color get _inputBg => _light ? const Color(0xFFF0F0F0) : const Color(0xFF2A2A2A);
  Color get _divider =>
      _light ? const Color(0xFFEBEBEB) : const Color(0xFF2C2C2C);
  Color get _sendActive => const Color(0xFF0095F6);

  @override
  void dispose() {
    _txtCtrl.clear();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  String? _replyParentId;
  String? _replyToUser;
  void startReply(Comment c) {
    setState(() {
      print(c.id);
      _replyParentId = c.id;
      _replyToUser = "${c.firstName ?? ''} ${c.lastName ?? ''}";
    });

    _txtCtrl.text = "@${c.firstName ?? ''} ";
    _focusNode.requestFocus();
  }
  // ── Actions ───────────────────────────────────────────────
  // Future<void> _send() async {
  //   final text = _txtCtrl.text.trim();
  //   if (text.isEmpty || _sending) return;
  //
  //   setState(() => _sending = true);
  //
  //   if (_editingCommentId != null) {
  //     await widget.controller.editComment(
  //       context,
  //       widget.postId,
  //       _editingCommentId!,
  //       text,
  //     );
  //     setState(() => _editingCommentId = null);
  //   } else {
  //     await widget.controller.addComment(context, widget.postId, text);
  //     _scrollToBottom();
  //   }
  //
  //   _txtCtrl.clear();
  //   setState(() => _sending = false);
  // }
  Future<void> _send() async {
    final text = _txtCtrl.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);

    if (_editingCommentId != null) {
      await widget.controller.editComment(
        context,
        widget.postId,
        _editingCommentId!,
        text,
      );
      _editingCommentId = null;
    }

    else if (_replyParentId != null) {
      await widget.controller.replyComment(
        context,
        widget.postId,
        _replyParentId!,
        text,
      );

      _replyParentId = null;
      _replyToUser = null;
      _scrollToBottom();
    }

    else {
      await widget.controller.addComment(
        context,
        widget.postId,
        text,
      );
      _scrollToBottom();
    }

    _txtCtrl.clear();
    setState(() => _sending = false);
  }
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startEdit(Comment c) {
    setState(() {
      _editingCommentId = c.id;
      _txtCtrl.text = c.comment ?? '';
    });
    _focusNode.requestFocus();
  }

  void _cancelEdit() {
    setState(() => _editingCommentId = null);
    _txtCtrl.clear();
    _focusNode.unfocus();
  }

  Future<void> _delete(String commentId) async {
    await widget.controller.deleteComment(context, widget.postId, commentId);
  }

  void _showOptions(Comment c) {
    if (c.userId != widget.controller.currentUserId.value) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 10),

                /// Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(height: 18),

                /// Edit
                _BetterOptionTile(
                  icon: Icons.edit_rounded,
                  label: "Edit comment".tr,
                  color: _textPrimary,
                  onTap: () {
                    Navigator.pop(context);
                    _startEdit(c);
                  },
                ),

                /// Delete
                _BetterOptionTile(
                  icon: Icons.delete_rounded,
                  label: "Delete comment".tr,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _delete(c.id ?? '');
                  },
                ),

                const SizedBox(height: 10),

                Divider(height: 1, color: _divider),

                /// Cancel button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: MyRegularText(
                        label: "Cancel".tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // ── Handle ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Title ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                MyRegularText(label:
                'Comments'.tr,

                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,

                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _inputBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close,
                        size: 16, color: _textPrimary),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _divider),

          // ── Comment list – reactive ─────────────────────────
          Expanded(
            child: Obx(() {
              final post = widget.controller.posts
                  .firstWhereOrNull((p) => p.id == widget.postId);
              final comments = post?.comment ?? [];

              if (comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 48,
                          color: _textSecondary.withOpacity(0.4)),
                      const SizedBox(height: 12),
                      MyRegularText(label:
                      'No comments yet'.tr,

                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _textPrimary),

                      const SizedBox(height: 6),
                      MyRegularText(label:
                      'Start the conversation'.tr,

                            fontSize: 13, color: _textSecondary),

                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                itemCount: comments.length,
                itemBuilder: (ctx, i) => _CommentTile(
                  comment: comments[i],
                  isEditing: _editingCommentId == comments[i].id,
                  textPrimary: _textPrimary,
                  textSecondary: _textSecondary,
                  onOptionsTap: () => _showOptions(comments[i]),
                  currentUserId: widget.controller.currentUserId.value,
                ),
              );
            }),
          ),

          Divider(height: 1, color: _divider),

          // ── Edit banner ────────────────────────────────────
          if (_editingCommentId != null)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF0095F6).withOpacity(0.08),
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 14, color: Color(0xFF0095F6)),
                  const SizedBox(width: 8),
                  Expanded(
                    child:              MyRegularText(label:
                    'Editing comment'.tr,

                        fontSize: 12,
                        color: Color(0xFF0095F6),
                        fontWeight: FontWeight.w500,

                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelEdit,
                    child:                MyRegularText(label:
                    'Cancel'.tr,

                        fontSize: 12,
                        color: Color(0xFF0095F6),
                        fontWeight: FontWeight.w600,

                    ),
                  ),
                ],
              ),
            ),

          // ── Input Row ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // User avatar
                Obx(() {
                  final url = widget.controller.currentUserProfileLink.value;
                  final hasPhoto = url.isNotEmpty;
                  return ProfileAvatar(
                    radius: 17,
                    imageUrl: url,
                    backgroundColor:
                        _light ? Colors.grey.shade300 : Colors.grey.shade700,
                    iconColor:
                        _light ? Colors.grey.shade600 : Colors.grey.shade400,
                    iconSize: 18,
                  );
                }),
                const SizedBox(width: 10),

                // Text input
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    decoration: BoxDecoration(
                      color: _inputBg,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _txtCtrl,
                            focusNode: _focusNode,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            style: TextStyle(
                                fontSize: 14,
                                color: _textPrimary,
                                height: 1.4),
                            decoration: InputDecoration(
                              hintText: _editingCommentId != null
                                  ? 'Edit your comment...'.tr
                                  : 'Add a comment for this post...'.tr,
                              hintStyle: TextStyle(
                                  fontSize: 14, color: _textSecondary),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              isDense: true,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),

                        // Send button
                        Padding(
                          padding: const EdgeInsets.only(right: 6, bottom: 6),
                          child: GestureDetector(
                            onTap: _txtCtrl.text.trim().isNotEmpty && !_sending
                                ? _send
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _txtCtrl.text.trim().isNotEmpty
                                    ? _sendActive
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: _sending
                                  ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              )
                                  : Icon(
                                Icons.arrow_upward_rounded,
                                size: 18,
                                color: _txtCtrl.text.trim().isNotEmpty
                                    ? Colors.white
                                    : _textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final bool isEditing;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onOptionsTap;
  final String? currentUserId;

  const _CommentTile({
    required this.comment,
    required this.isEditing,
    required this.textPrimary,
    required this.textSecondary,
    required this.onOptionsTap,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final name =
    '${comment.firstName ?? ''} ${comment.lastName ?? ''}'.trim();
    final isMyComment = comment.userId == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          ProfileAvatar(
            radius: 17,
            imageUrl: comment.photoUrl,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.grey.shade600,
            iconSize: 17,
          ),

          const SizedBox(width: 10),

          /// Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Editing badge
                if (isEditing)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0095F6).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const MyRegularText(
                      label: 'Editing…',
                      fontSize: 11,
                      color: Color(0xFF0095F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                /// Comment text
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.5,
                      color: textPrimary,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: '$name ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: comment.comment ?? ''),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                /// Actions
                Row(
                  children: [
                    MyRegularText(
                      label: 'Just now',
                      fontSize: 12,
                      color: textSecondary,
                    ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: () {
                        final sheet = context
                            .findAncestorStateOfType<_CommentSheetState>();
                        sheet?.startReply(comment);
                      },
                      child: MyRegularText(
                        label: 'Reply',
                        fontSize: 12,
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                /// Replies
                if ((comment.replies ?? []).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Column(
                      children: comment.replies!.map((reply) {
                        final replyName =
                        '${reply.firstName ?? ''} ${reply.lastName ?? ''}'
                            .trim();

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileAvatar(
                                radius: 14,
                                imageUrl: reply.photoUrl,
                                backgroundColor: Colors.grey.shade300,
                                iconColor: Colors.grey.shade600,
                                iconSize: 14,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textPrimary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "$replyName ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(text: reply.comment ?? ""),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),

          /// Options button
          if (isMyComment)
            GestureDetector(
              onTap: onOptionsTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
                child: Icon(Icons.more_horiz, size: 18, color: textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title:              MyRegularText(label:
      label,

            fontSize: 15, fontWeight: FontWeight.w500, color: color),

    );
  }
}class _BetterOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BetterOptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            /// Icon container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isLight
                    ? const Color(0xFFF5F5F5)
                    : const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),

            const SizedBox(width: 14),

            /// Label
            MyRegularText(
              label: label,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
