import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicorn/core/utils/media_open_helper.dart';
import 'package:unicorn/core/widget/empty_state.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../../widget/expandable_description.dart';
import '../controller/teacher_home_controller.dart';
import '../model/post_list/post_list_response.dart';
import 'comment_sheet.dart';

class ApiPostWidget extends StatefulWidget {
  final Post post;
  final TeacherHomeController controller;

  const ApiPostWidget({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  State<ApiPostWidget> createState() => _ApiPostWidgetState();
}

class _ApiPostWidgetState extends State<ApiPostWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double> _heartScale;
  late final Animation<double> _heartOpacity;

  void _sharePost() {
    final post = widget.post;

    final text = '''
Check out this post from ${post.teacher?.firstName ?? ''} ${post.teacher?.lastName ?? ''}

${post.description ?? ''}

${post.media?.isNotEmpty == true ? post.media!.first : ''}
''';

    Share.share(text.trim());
  }

  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  String get _id => widget.post.id ?? '';

  String get slug => widget.post.slug ?? '';

  List<String> get _media => widget.post.media ?? [];

  bool get _multi => _media.length > 1;

  Teacher? get _teacher => widget.post.teacher;

  bool get _isMyPost => widget.controller.isMyPost(widget.post);

  bool get _light => Theme.of(context).brightness == Brightness.light;

  Color get _textPrimary => _light ? const Color(0xFF111111) : Colors.white;

  Color get _textSecondary =>
      _light ? const Color(0xFF737373) : const Color(0xFF8E8E8E);

  Color get _iconColor => _light ? const Color(0xFF262626) : Colors.white;

  Color get _divider =>
      _light ? const Color(0xFFEBEBEB) : const Color(0xFF2C2C2C);

  @override
  void initState() {
    super.initState();

    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.3)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
    ]).animate(_heartCtrl);

    _heartOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartCtrl, curve: const Interval(0.0, 0.15)),
    );

    _heartCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        Future.delayed(
          const Duration(milliseconds: 400),
          () => mounted ? _heartCtrl.reverse() : null,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _heartCtrl.dispose();
    super.dispose();
  }

  void _doubleTapLike() {
    final liked = widget.controller.likedMap[_id] ?? false;
    if (!liked) widget.controller.toggleLike(context, _id);
    _heartCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  void _tapLike() {
    final wasLiked = widget.controller.likedMap[_id] ?? false;
    widget.controller.toggleLike(context, _id);
    if (!wasLiked) _heartCtrl.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: CommentSheet(
          postId: _id,
          controller: widget.controller,
        ),
      ),
    );
  }

  Future<void> _confirmDeletePost() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete post'),
            content: const Text(
              'Are you sure you want to delete this post?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) return;

    if (slug.isEmpty) return;
    await widget.controller.deletePost(context, slug);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        _buildCarousel(),
        _buildActions(),
        _buildLikesRow(),
        if (_media.isNotEmpty && (post.description?.isNotEmpty ?? false))
          _buildCaption(),
        _buildCommentPreview(),
        _buildDate(),
        SizedBox(height: 1, child: Divider(height: 1, color: _divider)),
      ],
    );
  }

  Widget _buildHeader() {
    final t = _teacher;
    final name = '${t?.firstName ?? ''} ${t?.lastName ?? ''}'.trim();
    final location = [t?.city, /*t?.state,*/ t?.country]
        .where((e) => e?.isNotEmpty ?? false)
        .join(', ');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 8, 10),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 20,
            imageUrl: t?.profileUrl,
            backgroundColor: Colors.grey.shade300,
            iconColor: _light ? Colors.grey.shade600 : Colors.white,
            iconSize: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: MyRegularText(
                        label: name.isEmpty ? 'Unknown' : name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified_rounded,
                        size: 13, color: Color(0xFF0095F6)),
                  ],
                ),
                if (location.isNotEmpty)
                  MyRegularText(
                    label: location,
                    fontSize: 11.5,
                    color: _textSecondary,
                  ),
              ],
            ),
          ),
          // if (_isMyPost)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDeletePost();
              }
            },
            icon: Icon(Icons.more_vert, color: _iconColor, size: 22),
            splashRadius: 20,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            itemBuilder: (_) => const [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    // if (_media.isEmpty) return const SizedBox.shrink();

    if (_media.isEmpty) {
      return Container(
        width: double.infinity,
        // constraints: const BoxConstraints(minHeight: 150),
        padding: const EdgeInsets.all(16),
        alignment: AlignmentDirectional.centerStart,
        // color: _light ? const Color(0xFFF6F7FB) : const Color(0xFF171717),
        child: ExpandableDescription(
          text:widget.post.description ?? '',
        ),
      );
    }

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _media.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (ctx, i) {
              final url = _media[i];
              final isPdf = url.toLowerCase().contains(".pdf");
              final isVideo = !isPdf &&
                  (url.toLowerCase().contains(".mp4") ||
                      url.toLowerCase().contains(".mov") ||
                      url.toLowerCase().contains(".m3u8"));

              return GestureDetector(
                onDoubleTap: isPdf ? null : _doubleTapLike,
                onTap: () => openDownloadableMedia(
                  url: url,
                  kind: isPdf
                      ? DownloadableKind.pdf
                      : isVideo
                          ? DownloadableKind.video
                          : DownloadableKind.image,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// IMAGE
                    if (isPdf) _buildPdfCard(url),
                    if (!isPdf && !isVideo)
                      Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),

                    /// VIDEO
                    if (isVideo) _VideoPlayerWidget(url: url),

                    /// Big heart animation
                    IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _heartCtrl,
                        builder: (_, __) {
                          final op = _heartOpacity.value;
                          if (op <= 0.01) return const SizedBox.shrink();
                          return Center(
                            child: Opacity(
                              opacity: op,
                              child: Transform.scale(
                                scale: _heartScale.value,
                                child: const Icon(
                                  Icons.favorite,
                                  size: 90,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black26, blurRadius: 20)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_multi)
          PositionedDirectional(
            top: 10,
            end: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MyRegularText(
                label: '${_currentPage + 1}/${_media.length}',
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPdfCard(String url) {
    final segments = Uri.tryParse(url)?.pathSegments ?? const <String>[];
    final fileName = segments.isNotEmpty ? segments.last : 'document.pdf';

    return Container(
      height: 168,
      color: _light ? const Color(0xFFF6F7FB) : const Color(0xFF171717),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _light ? Colors.white : const Color(0xFF222222),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.red,
              size: 42,
            ),
            const SizedBox(height: 10),
            Text(
              fileName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'tap_to_open_pdf'.tr,
              style: TextStyle(
                fontSize: 12,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 4),
      child: Row(
        children: [
          // ── Like ──────────────────────────────────────────
          // Reads likedMap[_id] which is seeded from API on load
          // and toggled optimistically on tap.
          Obx(() {
            final liked = widget.controller.likedMap.containsKey(_id)
                ? widget.controller.likedMap[_id]!
                : (widget.post.isLike ?? false);
            return GestureDetector(
              onTap: _tapLike,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 14),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    liked ? Icons.favorite : CupertinoIcons.heart,
                    key: ValueKey(liked),
                    color: liked ? const Color(0xFFED4956) : _iconColor,
                    size: 27,
                  ),
                ),
              ),
            );
          }),

          // ── Comment ───────────────────────────────────────
          GestureDetector(
            onTap: _openComments,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: SvgPicture.asset(
                'assets/svg/comment.svg',
                colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          // ── Share ─────────────────────────────────────────
          GestureDetector(
            onTap: _sharePost,
            child: SvgPicture.asset(
              'assets/svg/messanger.svg',
              colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
            ),
          ),

          const SizedBox(width: 60),
          if (_multi) _buildDots(),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_media.length, (i) {
        final active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: active ? 7 : 5,
          height: active ? 7 : 5,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF0095F6)
                : _textSecondary.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildLikesRow() {
    return Obx(() {
      final count = widget.controller.likeCountMap[_id] ?? 0;
      final liked = widget.controller.likedMap.containsKey(_id)
          ? widget.controller.likedMap[_id]!
          : (widget.post.isLike ?? false);
      final likes = widget.post.likes ?? [];
      void _openLikesSheet() {
        widget.controller.fetchLikeUsers(context, slug);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return LikeUsersSheet(
              controller: widget.controller,
              postSlug: slug,
            );
          },
        );
      }

      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 2, 12, 4),
        child: count <= 0
            ? GestureDetector(
                onTap: _tapLike,
                child: MyRegularText(
                  label: 'Be the first to like this',
                  fontSize: 13.5,
                  color: _textSecondary,
                ),
              )
            : Row(
                children: [
                  if (likes.isNotEmpty) ...[
                    SizedBox(
                      width: 20 + (likes.length - 1) * 12.0,
                      height: 20,
                      child: Stack(
                        children: [
                          for (int i = 0; i < likes.take(2).length; i++)
                            PositionedDirectional(
                              start: i * 12.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _light
                                        ? Colors.white
                                        : const Color(0xFF111111),
                                    width: 1.5,
                                  ),
                                ),
                                child: ProfileAvatar(
                                  radius: 9,
                                  imageUrl: likes[i].profileUrl,
                                  backgroundColor: Colors.grey.shade300,
                                  iconColor: Colors.white,
                                  iconSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: GestureDetector(
                      onTap: _openLikesSheet,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 13.5, color: _textPrimary),
                          children: [
                            TextSpan(text: '${'Liked by'.tr} '),
                            TextSpan(
                              text: liked
                                  ? 'you'.tr
                                  : (likes.isNotEmpty
                                      ? likes.first.firstName ?? 'someone'.tr
                                      : 'someone'.tr),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            if (count > 1)
                              TextSpan(
                                text:
                                    ' ${'and'.tr} ${count - 1} ${count - 1 == 1 ? 'other'.tr : 'others'.tr}',
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      );
    });
  }

  Widget _buildCaption() {
    final t = _teacher;
    final name = '${t?.firstName ?? ''} ${t?.lastName ?? ''}'.trim();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 2, 12, 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 13.5, color: _textPrimary, height: 1.4),
          children: [
            if (name.isNotEmpty)
              TextSpan(
                text: '$name ',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            TextSpan(text: widget.post.description ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentPreview() {
    return Obx(() {
      final post = widget.controller.posts.firstWhereOrNull((p) => p.id == _id);
      final comments = post?.comment ?? [];

      if (comments.isEmpty) return const SizedBox.shrink();

      return GestureDetector(
        onTap: _openComments,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (comments.length > 1)
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 2),
                  child: MyRegularText(
                    label: 'View all ${comments.length} comments',
                    fontSize: 13.5,
                    color: _textSecondary,
                  ),
                ),
              // RichText(
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   text: TextSpan(
              //     style: TextStyle(
              //         fontSize: 13.5, color: _textPrimary, height: 1.4),
              //     children: [
              //       TextSpan(
              //         text:
              //         '${comments.last.firstName ?? ''} ${comments.last.lastName ?? ''}'
              //             .trim(),
              //         style:
              //         const TextStyle(fontWeight: FontWeight.w700),
              //       ),
              //       const TextSpan(text: ' '),
              //       TextSpan(text: comments.last.comment ?? ''),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  // Widget _buildDate() {
  //   final date = widget.post.date ?? '';
  //   if (date.isEmpty) return const SizedBox(height: 10);
  //
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
  //     child: MyRegularText(
  //       label: date.toUpperCase(),
  //       fontSize: 10.5,
  //       color: _textSecondary,
  //       fontWeight: FontWeight.w500,
  //     ),
  //   );
  // }
  Widget _buildDate() {
    final rawDate = widget.post.date ?? '';
    if (rawDate.isEmpty) return const SizedBox(height: 10);

    String formattedDate = rawDate;

    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(rawDate);
      formattedDate = DateFormat('MMMM d').format(parsedDate);
    } catch (e) {
      debugPrint('Date parse error: $e');
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 10),
      child: MyRegularText(
        label: formattedDate,
        fontSize: 10.5,
        color: _textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String url;

  const _VideoPlayerWidget({required this.url});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ),

        /// Mute Button (Instagram style)
        PositionedDirectional(
          bottom: 12,
          end: 12,
          child: GestureDetector(
            onTap: _toggleMute,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LikeUsersSheet extends StatefulWidget {
  final TeacherHomeController controller;
  final String postSlug;

  const LikeUsersSheet({
    required this.controller,
    required this.postSlug,
  });

  @override
  State<LikeUsersSheet> createState() => _LikeUsersSheetState();
}

class _LikeUsersSheetState extends State<LikeUsersSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? Colors.white : const Color(0xFF111111);
    final surface = isLight ? const Color(0xFFF5F5F5) : const Color(0xFF1E1E1E);
    final textPrimary = isLight ? const Color(0xFF111111) : Colors.white;
    final textSecondary =
        isLight ? const Color(0xFF737373) : const Color(0xFF8E8E8E);
    final dividerColor =
        isLight ? const Color(0xFFEBEBEB) : const Color(0xFF2A2A2A);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.95,
      minChildSize: 0.45,
      snap: true,
      snapSizes: const [0.72, 0.95],
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Handle ─────────────────────────────────────────────
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Title ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Likes'.tr,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() {
                      final count = widget.controller.likeUsers.length;
                      if (count == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Search ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(CupertinoIcons.search,
                          size: 16, color: textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) =>
                              setState(() => _query = v.toLowerCase()),
                          style: TextStyle(
                              fontSize: 14,
                              color: textPrimary,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: 'Search...'.tr,
                            hintStyle:
                                TextStyle(fontSize: 14, color: textSecondary),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 10),
                            child: Icon(CupertinoIcons.xmark_circle_fill,
                                size: 16, color: textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),
              Divider(height: 1, color: dividerColor),

              // ── List ───────────────────────────────────────────────
              Expanded(
                child: Obx(() {
                  final users = widget.controller.likeUsers;
                  final isLoading = widget.controller.isLikeLoading.value;

                  if (isLoading && users.isEmpty) {
                    return _ShimmerList(isLight: isLight, surface: surface);
                  }

                  final filtered = _query.isEmpty
                      ? users
                      : users.where((u) {
                          final name =
                              '${u.firstName ?? ''} ${u.lastName ?? ''}'
                                  .toLowerCase();
                          final slug = (u.slug ?? '').toLowerCase();
                          return name.contains(_query) || slug.contains(_query);
                        }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: EmptyState());
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (info) {
                      if (info.metrics.pixels >=
                          info.metrics.maxScrollExtent - 80) {
                        widget.controller
                            .loadMoreLikes(context, widget.postSlug);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: filtered.length +
                          (isLoading && users.isNotEmpty ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == filtered.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }

                        final user = filtered[i];
                        final name =
                            '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                .trim();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          child: Row(
                            children: [
                              // Avatar
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: (user.profileLink?.isNotEmpty ??
                                              false)
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFF58529),
                                                Color(0xFFDD2A7B),
                                                Color(0xFF8134AF),
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                            )
                                          : null,
                                      color: (user.profileLink?.isEmpty ?? true)
                                          ? Colors.grey.shade300
                                          : null,
                                    ),
                                    child: ProfileAvatar(
                                      radius: 22,
                                      imageUrl: user.profileLink,
                                      backgroundColor: Colors.grey.shade300,
                                      iconColor: Colors.grey.shade600,
                                      iconSize: 20,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 12),

                              // Name & slug
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name.isEmpty ? 'Unknown' : name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (user.slug?.isNotEmpty ?? false)
                                      Text(
                                        '@${user.slug}',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              //
                              // const SizedBox(width: 10),
                              //
                              // // Follow button
                              // _FollowButton(isLight: isLight),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Follow Button ────────────────────────────────────────────────────────────

class _FollowButton extends StatefulWidget {
  final bool isLight;
  const _FollowButton({required this.isLight});

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _following = !_following),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: _following
              ? (widget.isLight
                  ? const Color(0xFFF0F0F0)
                  : const Color(0xFF2A2A2A))
              : const Color(0xFF0095F6),
          borderRadius: BorderRadius.circular(10),
          border: _following
              ? Border.all(
                  color: widget.isLight
                      ? const Color(0xFFDBDBDB)
                      : const Color(0xFF3A3A3A),
                  width: 1,
                )
              : null,
        ),
        child: Text(
          _following ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _following
                ? (widget.isLight ? const Color(0xFF111111) : Colors.white)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Shimmer Skeleton ─────────────────────────────────────────────────────────

class _ShimmerList extends StatefulWidget {
  final bool isLight;
  final Color surface;
  const _ShimmerList({required this.isLight, required this.surface});

  @override
  State<_ShimmerList> createState() => _ShimmerListState();
}

class _ShimmerListState extends State<_ShimmerList>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                _shimmerCircle(48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 130, height: 13),
                      const SizedBox(height: 6),
                      _shimmerBox(width: 90, height: 11),
                    ],
                  ),
                ),
                _shimmerBox(width: 76, height: 32, radius: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBox(
      {required double width, required double height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value, 0),
          colors: widget.isLight
              ? [
                  const Color(0xFFE8E8E8),
                  const Color(0xFFF4F4F4),
                  const Color(0xFFE8E8E8),
                ]
              : [
                  const Color(0xFF2A2A2A),
                  const Color(0xFF333333),
                  const Color(0xFF2A2A2A),
                ],
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value, 0),
          colors: widget.isLight
              ? [
                  const Color(0xFFE8E8E8),
                  const Color(0xFFF4F4F4),
                  const Color(0xFFE8E8E8),
                ]
              : [
                  const Color(0xFF2A2A2A),
                  const Color(0xFF333333),
                  const Color(0xFF2A2A2A),
                ],
        ),
      ),
    );
  }
}
