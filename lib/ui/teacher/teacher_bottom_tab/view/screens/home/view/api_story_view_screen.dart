import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/service/api_service/api_worker.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../common_screens/story_view/model/story_like/story_like_request.dart';
import '../controller/teacher_home_controller.dart';
import '../../profile/controller/teacher_profile_controller.dart';
import '../model/story_listing/story_listing_response.dart';

// ══════════════════════════════════════════════════════════════
//  ApiStoryViewScreen  –  Instagram-style fullscreen story viewer
//  Takes the API [Story] model directly (no wrapper needed)
// ══════════════════════════════════════════════════════════════
class ApiStoryViewScreen extends StatefulWidget {
  final String? teacherProfileLink;
  final int initialIndex;
  final bool? isTeacher;
  final List<StoryUser> storyUsers;
  final int initialUserIndex;
  final int initialStoryIndex;

  const ApiStoryViewScreen({
    super.key,
    required this.isTeacher,
    this.teacherProfileLink,
    this.initialIndex = 0,
    required this.storyUsers,
    this.initialUserIndex = 0,
    this.initialStoryIndex = 0,
  });

  @override
  State<ApiStoryViewScreen> createState() => _ApiStoryViewScreenState();
}

class _ApiStoryViewScreenState extends State<ApiStoryViewScreen>
    with SingleTickerProviderStateMixin {
  final TeacherHomeController homeCtrl = Get.find<TeacherHomeController>();
  late PageController _pageCtrl;
  late AnimationController _animCtrl;

  int _storyIdx = 0;
  bool _isPaused = false;

  final Set<String> _viewedStoryIds = {};
  // Per-story like state
  final Map<String, bool> _liked = {};

  bool _showHeart = false;
  double _heartScale = 0.0;
  String _activeStoryLikeId = '';

  String get _mediaUrl => _current.mediaUrl ?? '';
  int _userIdx = 0;
  StoryUser get _currentUser => widget.storyUsers[_userIdx];

  List<StoryList> get _stories => _currentUser.stories ?? [];

  StoryList get _current => _stories[_storyIdx];
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _userIdx = widget.initialUserIndex;
  //   _storyIdx = widget.initialStoryIndex;
  //
  //   _pageCtrl = PageController(initialPage: _storyIdx);
  //
  //   _animCtrl = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 5),
  //   )..addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       _onTimerComplete();
  //     }
  //   });
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _handleStoryStart(_storyIdx);
  //
  //     Future.delayed(const Duration(milliseconds: 800), () {
  //       _callViewApiOnce(_current.id);
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();

    _userIdx = widget.initialUserIndex;
    _storyIdx = widget.initialStoryIndex;

    _pageCtrl = PageController(initialPage: _storyIdx);

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onTimerComplete();
      }
    });

    /// ✅ ADD THIS BLOCK
    _initializeLikes();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStoryStart(_storyIdx);

      Future.delayed(const Duration(milliseconds: 800), () {
        _callViewApiOnce(_current.id);
      });
    });
  }
  void _initializeLikes() {
    for (final user in widget.storyUsers) {
      for (final story in user.stories ?? []) {
        final id = story.id;
        if (id != null) {
          _liked[id] = story.isLiked ?? false; // ✅ from API
        }
      }
    }
  }
  void _handleStoryStart(int index) {
    final story = _stories[index];
    final url = story.mediaUrl ?? '';

    _stopAllVideos();
    _animCtrl.stop();
    _animCtrl.reset();

    bool isVideo = url.toLowerCase().endsWith(".mp4") ||
        url.toLowerCase().endsWith(".mov") ||
        url.toLowerCase().endsWith(".mkv");

    if (isVideo) {
      _initVideo(index, url);
    } else {
      _animCtrl.duration = const Duration(seconds: 5);
    }
  }
  void _callViewApiOnce(String? id) async {
    if (id == null || _viewedStoryIds.contains(id)) return;

    _viewedStoryIds.add(id);

    try {
      await ApiWorker().storyView(context, id);
    } catch (e) {
      debugPrint("Story view error: $e");
    }
  }
  void _initVideo(int index, String url) async {
    if (_videoControllers.containsKey(index)) {
      final controller = _videoControllers[index]!;

      if (controller.value.isInitialized) {
        _startVideo(controller);
      }
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    await controller.initialize();

    _videoControllers[index] = controller;

    if (!mounted) return;

    setState(() {});

    _startVideo(controller);
  }

  void _startVideo(VideoPlayerController controller) {
    controller.play();

    _animCtrl.stop();
    _animCtrl.reset();

    _animCtrl.duration = controller.value.duration;

    if (!_isPaused) {
      _animCtrl.forward();
    }
  }
  final Map<int, VideoPlayerController> _videoControllers = {};

  void _onTimerComplete() {
    if (!mounted) return;

    if (_storyIdx < _stories.length - 1) {
      _goToStory(_storyIdx + 1);
    } else {
      if (_userIdx < widget.storyUsers.length - 1) {
        _goToUser(_userIdx + 1);
      } else {
        _exitScreen();
      }
    }
  }
  void _goTo(int idx) {
    if (idx < 0 || idx >= _stories.length) return;

    _stopAllVideos();

    setState(() {
      _storyIdx = idx;
    });

    _pageCtrl.jumpToPage(idx);

    _handleStoryStart(idx);

    // ✅ delay view (important)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _storyIdx == idx) {
        _callViewApiOnce(_stories[idx].id);
      }
    });
  }void _exitScreen() {
    _stopAllVideos();
    Get.back();
  }

  void _prev() {
    if (_storyIdx > 0) {
      _goToStory(_storyIdx - 1);
    } else {
      if (_userIdx > 0) {
        _goToUser(_userIdx - 1);

        // go to last story of previous user
        Future.delayed(const Duration(milliseconds: 100), () {
          final lastIndex = _stories.length - 1;
          _goToStory(lastIndex);
        });
      } else {
        _animCtrl.reset();
        _animCtrl.forward();
      }
    }
  }
  void _goToStory(int idx) {
    if (idx < 0 || idx >= _stories.length) return;

    _stopAllVideos();

    setState(() {
      _storyIdx = idx;
    });

    _pageCtrl.jumpToPage(idx);

    _handleStoryStart(idx);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _storyIdx == idx) {
        _callViewApiOnce(_stories[idx].id);
      }
    });
  }
  void _next() {
    if (_storyIdx < _stories.length - 1) {
      _goToStory(_storyIdx + 1);
    } else {
      // 🔥 MOVE TO NEXT USER
      if (_userIdx < widget.storyUsers.length - 1) {
        _goToUser(_userIdx + 1);
      } else {
        _exitScreen(); // last user → exit
      }
    }
  }
  void _goToUser(int userIdx) {
    if (userIdx >= widget.storyUsers.length) {
      _exitScreen();
      return;
    }

    _stopAllVideos();

    setState(() {
      _userIdx = userIdx;
      _storyIdx = 0;

      _pageCtrl = PageController(initialPage: 0); // ✅ IMPORTANT
    });

    _handleStoryStart(0);

    Future.delayed(const Duration(milliseconds: 800), () {
      _callViewApiOnce(_current.id);
    });
  }
  void _pause() {
    if (_isPaused) return;

    _isPaused = true;
    _animCtrl.stop();

    _videoControllers[_storyIdx]?.pause();
  }

  void _resume() {
    if (!_isPaused) return;

    _isPaused = false;
    _animCtrl.forward();

    _videoControllers[_storyIdx]?.play();
  }
  // ─── Gesture Handlers ────────────────────────────────────
  void _onTapDown(TapDownDetails d) {
    final w = MediaQuery.of(context).size.width;
    final dx = d.globalPosition.dx;
    if (dx < w * 0.33) {
      _prev();
    } else if (dx > w * 0.66) {
      _next();
    } else {
      _isPaused ? _resume() : _pause();
    }
  }

  Future<void> _onDoubleTap() async {
    final id = _current.id ?? '';
    final nowLiked = !(_liked[id] ?? false);
    setState(() {
      _liked[id] = nowLiked;
      _showHeart = true;
      _heartScale = 0.8;
    });
    await Future.delayed(const Duration(milliseconds: 35));
    setState(() => _heartScale = 1.15);
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() => _heartScale = 1.0);
    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      _showHeart = false;
      _heartScale = 0.0;
    });
  }

  void _onVerticalDrag(DragUpdateDetails d) {
    if (d.delta.dy > 12) {
      _stopAllVideos();
      Get.back();
    }
  }

  // ─── Progress bars ───────────────────────────────────────
  Widget _buildProgressBars() {
    return Row(
      children: _stories.asMap().entries.map((e) {
        final i = e.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedBuilder(
              animation: _animCtrl,
              builder: (_, __) {
                double progress;
                if (i < _storyIdx) {
                  progress = 1.0;
                } else if (i > _storyIdx) {
                  progress = 0.0;
                } else {
                  progress = _animCtrl.value.clamp(0.0, 1.0);
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeader() {
    final st = _current;
    final teacherName = _currentUser.teacherName ?? '';
    final teacherProfileLink = _currentUser.teacherProfileLink;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.75),
            Colors.black.withOpacity(0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressBars(),
          SizedBox(height: 2.h),
          Row(
            children: [
              // Avatar
              Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ProfileAvatar(
                  radius: 20,
                  imageUrl: teacherProfileLink,
                  backgroundColor: Colors.grey.shade400,
                  iconColor: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyRegularText(label:
                    teacherName,

                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,


                    ),
                    // if (st.expiresAt != null)
                    //   MyRegularText(label:
                    //   _timeAgo(st.expiresAt!),
                    //
                    //       fontSize: 12.sp,
                    //       color: Colors.white.withOpacity(0.8),

                      // ),
                  ],
                ),
              ),
              if (_isMyStory)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDeleteStory();
                    }
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 24,
                  ),
                  itemBuilder: (_) => const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              if (_isMyStory) SizedBox(width: 2.w),
              // Close
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
  final TeacherProfileController profileCtrl =
  Get.put(TeacherProfileController());

  bool get _isMyStory {
    final myId = profileCtrl.teacher.value?.id;
    return _currentUser.teacherId == myId;
  }

  Future<void> _confirmDeleteStory() async {
    final storyId = _current.id;
    if (storyId == null) return;

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete story'),
            content: const Text(
              'Are you sure you want to delete this story?',
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

    final didDelete = await homeCtrl.deleteStory(context, storyId);
    if (didDelete && mounted) {
      Get.back();
    }
  }

  Widget _buildBottomBar() {
    final id = _current.id ?? '';
    final isLiked = _liked[id] ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.75),
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(3.w, 3.h, 3.w, 2.h),
          child: Row(
            children: [
              Visibility(
                visible: _isMyStory,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _openViewers,
                      child: _glassCircle(
                        child: const Icon(Icons.remove_red_eye, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 3.w),
                  ],
                ),
              ),
              // Like button

              Visibility(
                visible:widget.isTeacher == false,
                child: GestureDetector(
                  onTap: _activeStoryLikeId == _current.id
                      ? null
                      : () async {
                    final id = _current.id;
                    if (id == null) return;

                    final newLike = !isLiked;
                    setState(() {
                      _activeStoryLikeId = id;
                      _liked[id] = newLike;
                      _current.isLiked = newLike; // ✅ IMPORTANT
                    });
                    try {
                      await ApiWorker().storyLike(
                        context,
                        id,
                        StoryLikeRequest(isLike: newLike),
                      );
                    } catch (e) {
                      debugPrint("Like error: $e");
                    } finally {
                      if (mounted) {
                        setState(() {
                          _activeStoryLikeId = '';
                        });
                      }
                    }
                  },
                  child: _glassCircle(
                    child: _activeStoryLikeId == _current.id
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(),
                          )
                        : Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _openViewers() async {
    final id = _current.id;
    if (id == null) return;

    try {
      final res = await ApiWorker().storyUserListView(context, id);

      final views = res?.data?.views ?? [];

// ✅ Sort: liked first
      views.sort((a, b) {
        final aLiked = a.storyLiked == true ? 1 : 0;
        final bLiked = b.storyLiked == true ? 1 : 0;
        return bLiked.compareTo(aLiked);
      });
      final count = res?.data?.count ?? 0;

      Get.bottomSheet(
        Container(
          height: 65.h,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 HEADER (like Instagram)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${'Views'.tr} ($count)",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 10),

              // 🔥 EMPTY STATE
              if (views.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "No views yet",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: views.length,
                    itemBuilder: (_, i) {
                      final user = views[i];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ProfileAvatar(
                          radius: 20,
                          imageUrl: user.photoUrl,
                          backgroundColor: Colors.grey,
                          iconColor: Colors.white,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${user.firstName ?? ''} ${user.lastName ?? ''}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            // ❤️ Like indicator
                            if (user.storyLiked == true)
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      debugPrint("Viewer list error: $e");
    }
  }
  void _startTimer() {
    if (!mounted) return;
    _animCtrl.stop();
    _animCtrl.reset();
    _animCtrl.duration =
    const Duration(seconds: 5); // one frame per story entry
    if (!_isPaused) _animCtrl.forward();
  }
  Widget _glassCircle({required Widget child}) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Center(child: child),
    );
  }

  // ── Overlay text / CTA ──────────────────────────────────────
  Widget _buildStoryOverlay() {
    final st = _current;

    if ((st.text?.isEmpty ?? true) && (st.ctaText?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (st.text?.isNotEmpty ?? false)
              MyRegularText(label:
              st.text!,

                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,

              ),
            if (st.ctaText?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child:    MyRegularText(label:
                st.ctaText!,

                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,

                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _stopAllVideos();

    for (final c in _videoControllers.values) {
      c.dispose();
    }

    _animCtrl.dispose();
    _pageCtrl.dispose();

    super.dispose();
  }
  void _onStoryVisible(int index) async {
    final story = _stories[index];

    if (story.id != null) {
      try {
        await ApiWorker().storyView(context, story.id);
      } catch (e) {
        debugPrint("Story view error: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onDoubleTap: _onDoubleTap,
          onLongPress: _pause,
          onLongPressUp: _resume,
          onVerticalDragUpdate: _onVerticalDrag,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Media ─────────────────────────────────────
              PageView.builder(
                key: ValueKey(_userIdx), // 🔥 VERY IMPORTANT (forces rebuild)
                controller: _pageCtrl,
                itemCount: _stories.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _storyIdx = idx);
                  _handleStoryStart(idx);
                },
                itemBuilder: (_, idx) {
                  final url = _stories[idx].mediaUrl ?? '';
                  bool isVideo = url.toLowerCase().endsWith(".mp4") ||
                      url.toLowerCase().endsWith(".mov") ||
                      url.toLowerCase().endsWith(".mkv");

                  if (isVideo) {
                    _initVideo(idx, url);

                    final controller = _videoControllers[idx];

                    if (controller == null || !controller.value.isInitialized) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    );
                  }

                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) {
                        if (!_animCtrl.isAnimating && !_isPaused) {
                          _animCtrl
                            ..stop()
                            ..reset()
                            ..forward();
                        }
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),

              // ── Story text / CTA overlay ───────────────────
              _buildStoryOverlay(),

              // ── Tap Zones ─────────────────────────────────
              Positioned.fill(
                child: Row(
                  children: [
                    // LEFT → PREVIOUS
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _prev,
                        onLongPress: _pause,
                        onLongPressUp: _resume,
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // RIGHT → NEXT
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _next,
                        onLongPress: _pause,
                        onLongPressUp: _resume,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Header (progress + user info) ─────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(),
              ),

              // ── Heart animation ────────────────────────────
              if (_showHeart)
                Center(
                  child: AnimatedScale(
                    scale: _heartScale,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.elasticOut,
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 120),
                  ),
                ),

              // ── Bottom reply bar ───────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt).abs();
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _stopAllVideos() {
    for (final controller in _videoControllers.values) {
      try {
        controller.pause();
        controller.setVolume(0);
      } catch (_) {}
    }
  }
}
