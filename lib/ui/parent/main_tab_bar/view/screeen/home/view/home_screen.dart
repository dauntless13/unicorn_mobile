import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';

import '../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/controller/teacher_home_controller.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/model/story_listing/story_listing_response.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/api_story_view_screen.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/home/view/notification_list_screen.dart';
import '../../../../../../teacher/teacher_bottom_tab/view/screens/profile/controller/teacher_profile_controller.dart';
import '../../../../controller/maintab_controller.dart';
import '../../profile/view/controller/parent_profile_controller.dart';
import 'api_post_widget_parent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TeacherHomeController ctrl = Get.put(TeacherHomeController());
  final ParentProfileController parentProfileController =
      Get.put(ParentProfileController());
  final TeacherProfileController profileCtrl =
      Get.put(TeacherProfileController());

  late final EasyRefreshController _refreshCtrl;

  bool get _light => Theme.of(context).brightness == Brightness.light;
  Color get _bg => _light ? Colors.white : const Color(0xFF111111);
  Color get _headerBg => _light ? Colors.white : const Color(0xFF1C1C1C);
  Color get _divider =>
      _light ? const Color(0xFFEBEBEB) : const Color(0xFF2C2C2C);
  Color get _textPrimary => _light ? const Color(0xFF111111) : Colors.white;
  Color get _textSecondary =>
      _light ? const Color(0xFF737373) : const Color(0xFF8E8E8E);

  @override
  void initState() {
    super.initState();
    _refreshCtrl = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.initData(context);
      parentProfileController.parentGetBySlug(context);
    });
  }

  @override
  void dispose() {
    _refreshCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ctrl.fetchStories(context);
    await ctrl.fetchPosts(context, refresh: true);
    _refreshCtrl.finishRefresh();
  }

  Future<void> _onLoad() async {
    await ctrl.loadMore(context);
    _refreshCtrl.finishLoad(
      ctrl.canLoadMore ? IndicatorResult.success : IndicatorResult.noMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Sticky Header ──────────────────────────────────
            _buildHeader(),
            SizedBox(height: 16),
            // ── Scrollable Feed ────────────────────────────────
            Expanded(
              child: Obx(() {
                final isInitialLoading =
                    ctrl.isStoryLoading.value || ctrl.isPostLoading.value;

                if (isInitialLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return EasyRefresh(
                  controller: _refreshCtrl,
                  onRefresh: _onRefresh,
                  onLoad: _onLoad,
                  header: const ClassicHeader(showText: false),
                  footer: const ClassicFooter(showText: false),
                  child: CustomScrollView(
                    slivers: [
                      Obx(() {
                        if (ctrl.storyUsers.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            _buildStoriesSection(),
                            Divider(height: 1, color: _divider),
                          ]),
                        );
                      }),
                      if (ctrl.posts.isEmpty)
                        const SliverFillRemaining(
                          child: EmptyState(),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => ApiPostWidgetParent(
                              post: ctrl.posts[i],
                              controller: ctrl,
                            ),
                            childCount: ctrl.posts.length,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────
  Widget _buildHeader() {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      height: 52,
      color: _headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Obx(() {
            final t = parentProfileController.parent.value;

            return ProfileAvatar(
              radius: 20,
              imageUrl: t?.nurseryLogo,
              backgroundColor: Colors.grey.shade300,
              iconColor: Colors.white,
            );
          }),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Obx(() {
                final data = parentProfileController.parent.value;

                if (data == null) {
                  return const SizedBox();
                }

                return Align(
                  alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // MyRegularText(
                      //   label: 'ID : ${data.parentCode ?? ''}'.tr,
                      //   fontSize: 14,
                      //   color: _textSecondary,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      MyRegularText(
                        label: '${data?.nurseryName ?? ''}'.trim(),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(NotificationScreen());
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: SvgPicture.asset(
                    'assets/svg/notification.svg',
                    width: 24,
                    colorFilter:
                        ColorFilter.mode(_textPrimary, BlendMode.srcIn),
                  ),
                ),
              ),
              Obx(() {
                final t = parentProfileController.parent.value;

                return GestureDetector(
                  onTap: () {
                    final tabController = Get.find<MainTabController>();
                    tabController.changeTab(4); // Profile tab index
                  },
                  child: ProfileAvatar(
                    radius: 20,
                    imageUrl: t?.profileLink,
                    backgroundColor: Colors.grey.shade300,
                    iconColor: Colors.white,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stories Section
  Widget _buildStoriesSection() {
    return Obx(() {
      final users = ctrl.storyUsers;

      // 🚀 If empty → remove space completely
      if (users.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemCount: users.length,
          itemBuilder: (ctx, i) {
            final user = users[i];

            return _StoryAvatar(
              user: user,
              onTap: () {
                final stories = user.stories ?? [];
                if (stories.isEmpty) return;

                Get.to(() => ApiStoryViewScreen(
                      storyUsers: users, // 🔥 ALL USERS
                      initialUserIndex: i, // 🔥 CURRENT USER INDEX
                      initialStoryIndex: 0,
                      isTeacher: false,
                    ))?.then((_) {
                  ctrl.fetchStories(context);
                });
              },
            );
          },
        ),
      );
    });
  }

  // ── Empty feed ──────────────────────────────────────────────────
  Widget _buildEmptyFeed() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_outlined,
              size: 56, color: _textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          MyRegularText(
            label: 'No posts yet',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
          const SizedBox(height: 8),
          MyRegularText(
              label: 'Pull down to refresh',
              fontSize: 14,
              color: _textSecondary),
        ],
      ),
    );
  }
}

// ── Story Avatar ─────────────────────────────────────────────────
class _StoryAvatar extends StatelessWidget {
  final StoryUser user;
  final VoidCallback onTap;

  const _StoryAvatar({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final name = user.teacherName ?? '';
    final shortName = name.length > 10 ? '${name.substring(0, 9)}…' : name;
    final hasUnviewed = (user.stories ?? []).any((s) => s.storyViewed != true);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 66,
              height: 66,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnviewed
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.grey.shade400,
                          Colors.grey.shade400,
                        ],
                      ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLight ? Colors.white : const Color(0xFF111111),
                    width: 2,
                  ),
                ),
                child: ProfileAvatar(
                  radius: 20,
                  imageUrl: user.teacherProfileLink,
                  backgroundColor: Colors.grey.shade300,
                  iconColor: Colors.white,
                  iconSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 5),
            MyRegularText(
              label: shortName,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isLight ? const Color(0xFF262626) : Colors.white,
              maxlines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
