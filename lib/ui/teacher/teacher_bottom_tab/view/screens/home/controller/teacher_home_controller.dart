

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../service/session/session_helper.dart';
import '../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../translation/language_controller.dart';
import '../model/add_comment/add_comment_request.dart';
import '../model/add_comment/add_comment_response.dart';
import '../model/delete_comment/delete_comment_request.dart';
import '../model/delete_post/delete_post_request.dart';
import '../model/delete_story/delete_story_request.dart';
import '../model/edit_comment/edit_comment_request.dart';
import '../model/like_listing/like_listing_request.dart';
import '../model/like_listing/like_listing_response.dart';
import '../model/like_post/like_post_request.dart';
import '../model/post_list/post_list_request.dart';
import '../model/post_list/post_list_response.dart';
import '../model/reply_comment/reply_comment_request.dart';
import '../model/save_post/save_post_request.dart';
import '../model/story_listing/story_listing_request.dart';
import '../model/story_listing/story_listing_response.dart';

class TeacherHomeController extends GetxController {

  final ApiWorker apiWorker = Get.put(ApiWorker()) ;
  final RxString currentUserProfileLink = ''.obs;

  // ─── State ───────────────────────────────────────────────
  final RxList<Post> posts = <Post>[].obs;
  final RxList<StoryUser> storyUsers = <StoryUser>[].obs;

  final RxBool isPostLoading = true.obs;
  final RxBool isStoryLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString currentUserId = ''.obs;
  // Per-post like / save state (postId → bool)
  final RxMap<String, bool> likedMap = <String, bool>{}.obs;
  final RxMap<String, bool> savedMap = <String, bool>{}.obs;
  final RxMap<String, int> likeCountMap = <String, int>{}.obs;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool get canLoadMore => _currentPage < _totalPages;

  // ─── Init ─────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserProfile();
    // Context is needed for API calls — called from Screen via initState
  }

  Future<void> _loadCurrentUserProfile() async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      currentUserProfileLink.value =
          loginResponse?.data?.user?.profileLink ?? "";    currentUserId.value =
          loginResponse?.data?.user?.id ?? "";

    } catch (_) {
      currentUserProfileLink.value = "";
    }
  }
  void initData(BuildContext context) {
    fetchPosts(context, refresh: true);
    fetchStories(context);

  }

  // ─── Stories ──────────────────────────────────────────────
  Future<void> fetchStories(BuildContext context) async {
    isStoryLoading.value = true;

    try {
      final response = await apiWorker.storyListing(
        StoryListingRequest(lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true &&
          response?.data?.users != null) {
        storyUsers.value = response!.data!.users!;
      }
    } catch (e) {
      debugPrint('Story fetch error: $e');
    } finally {
      isStoryLoading.value = false;
    }
  }

  // ─── Posts ────────────────────────────────────────────────
  Future<void> fetchPosts(
    BuildContext context, {
    bool refresh = false,
    bool silently = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      if (!silently) {
        posts.clear();
        isPostLoading.value = true;
      }
    } else {
      if (isLoadingMore.value || !canLoadMore) return;
      isLoadingMore.value = true;
    }

    try {
      final response = await apiWorker.postListingApi(
        PostListRequest(lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true && response?.data?.posts != null) {
        final newPosts = response!.data!.posts!;

        // Seed local like/save state from response data
        for (final post in newPosts) {
          final id = post.id ?? '';

          /// ✅ seed from API
          likedMap[id] = post.isLike ?? false;
          savedMap[id] = post.isSave ?? false;

          likeCountMap[id] =
              post.totalLikeCount ?? likeCountMap[id] ?? 0;
        }
        if (refresh) {
          posts.value = newPosts;
        } else {
          posts.addAll(newPosts);
        }

        final pagination = response.data!.pagination;
        _currentPage = pagination?.currentPage ?? 1;
        _totalPages = pagination?.totalPages ?? 1;
      }
    } catch (e) {
      debugPrint('Post fetch error: $e');
    } finally {
      if (!silently) {
        isPostLoading.value = false;
      }
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshPostsSilently(BuildContext context) async {
    await fetchPosts(context, refresh: true, silently: true);
  }

  Future<void> loadMore(BuildContext context) async {
    if (!canLoadMore || isLoadingMore.value) return;
    _currentPage++;
    await fetchPosts(context);
  }

  bool isMyPost(Post post) {
    final currentProfile = currentUserProfileLink.value.trim();
    final postProfile = post.teacher?.profileUrl?.trim() ?? '';
    return currentProfile.isNotEmpty && currentProfile == postProfile;
  }

  // ─── Like ─────────────────────────────────────────────────
  Future<void> toggleLike(
      BuildContext context,
      String postId,
      ) async {
    final current = likedMap[postId] ?? false;
    final newValue = !current;

    /// ✅ optimistic update
    likedMap[postId] = newValue;

    likeCountMap[postId] =
        (likeCountMap[postId] ?? 0) +
            (newValue ? 1 : -1);

    try {
      final res = await apiWorker.likePostApi(
        LikeRequest(
          lang: LanguageController.to.apiLanguage,
          isLike: newValue,
        ),
        context,
        postId,
      );

      /// rollback if failed
      if (res?.success != true) {
        likedMap[postId] = current;
        likeCountMap[postId] =
            (likeCountMap[postId] ?? 0) +
                (newValue ? -1 : 1);
      }
    } catch (_) {
      likedMap[postId] = current;
    }
  }
  // ─── Save ─────────────────────────────────────────────────
  Future<void> toggleSave(
      BuildContext context,
      String postId,
      ) async {
    final current = savedMap[postId] ?? false;
    final newValue = !current;

    /// optimistic update
    savedMap[postId] = newValue;

    try {
      final res = await apiWorker.savePostApi(
        SaveRequest(
          lang: LanguageController.to.apiLanguage,
          save: newValue,
        ),
        context,
        postId,
      );

      if (res?.success != true) {
        savedMap[postId] = current;
      }
    } catch (_) {
      savedMap[postId] = current;
    }
  }

  // ─── Add Comment ──────────────────────────────────────────
  Future<Comment?> addComment(
      BuildContext context,
      String postId,
      String commentText,
      ) async {
    try {
      final response = await apiWorker.addCommentApi(
        AddCommentRequest(comment: commentText, lang:LanguageController.to.apiLanguage),
        context,
        postId,
      );

      if (response?.success == true) {
        await refreshPostsSilently(context);
        final idx = posts.indexWhere((p) => p.id == postId);
        final refreshedComments =
            idx != -1 ? (posts[idx].comment ?? <Comment>[]) : <Comment>[];
        return refreshedComments.isNotEmpty ? refreshedComments.last : null;
      }
    } catch (e) {
      debugPrint('Add comment error: $e');
    }
    return null;
  }

  // ─── Edit Comment ─────────────────────────────────────────
  Future<bool> editComment(
      BuildContext context,
      String postId,
      String commentId,
      String newText,
      ) async {
    try {
      final response = await apiWorker.editCommentApi(
        EditCommentRequest(comment: newText, lang: LanguageController.to.apiLanguage),
        context,
        commentId,
      );

      if (response?.success == true) {
        final idx = posts.indexWhere((p) => p.id == postId);
        if (idx != -1) {
          final post = posts[idx];
          final updatedComments = (post.comment ?? []).map<Comment>((c) {
            return c.id == commentId ? c.copyWith(comment: newText) : c;
          }).toList();
          posts[idx] = post.copyWith(comment: updatedComments);
        }
        return true;
      }
    } catch (e) {
      debugPrint('Edit comment error: $e');
    }
    return false;
  }

  // ─── Delete Comment ───────────────────────────────────────
  Future<bool> deleteComment(
      BuildContext context,
      String postId,
      String commentId,
      ) async {
    try {
      final response = await apiWorker.deleteCommentApi(
        DeleteCommentRequest(lang: LanguageController.to.apiLanguage),
        context,
        commentId,
      );

      if (response?.success == true) {
        final idx = posts.indexWhere((p) => p.id == postId);
        if (idx != -1) {
          final post = posts[idx];
          final updatedComments =
          (post.comment ?? []).where((c) => c.id != commentId).toList().cast<Comment>();
          posts[idx] = post.copyWith(comment: updatedComments);
        }
        return true;
      }
    } catch (e) {
      debugPrint('Delete comment error: $e');
    }
    return false;
  }
  String? _replyParentId;
  String? _replyToUser;
  Future<Comment?> replyComment(
      BuildContext context,
      String postId,
      String parentCommentId,
      String replyText,
      ) async {
    try {
      final response = await apiWorker.replyComment(
        context,
        parentCommentId,
        ReplyCommentRequest(
          comment: replyText,
          lang: LanguageController.to.apiLanguage,
        ),
      );

      if (response?.success == true) {
        await refreshPostsSilently(context);
        return null;
      }
    } catch (e) {
      debugPrint("Reply comment error: $e");
    }

    return null;
  }
// ─── Like Listing ─────────────────────────────────────────

  final RxList<LikeListing> likeUsers = <LikeListing>[].obs;
  final RxBool isLikeLoading = false.obs;

  int _likePage = 1;
  int _likeTotalPages = 1;
  bool get canLoadMoreLikes => _likePage < _likeTotalPages;

  Future<void> fetchLikeUsers(
      BuildContext context,
      String postSlug, {
        bool refresh = true,
      }) async {
    if (refresh) {
      _likePage = 1;
      likeUsers.clear();
      isLikeLoading.value = true;
    }

    try {
      final res = await apiWorker.likeListing(
        LikeListingRequest(
          lang: LanguageController.to.apiLanguage,
          page: _likePage,
          limit: 20,
        ),
        postSlug,
        context,
      );

      if (res?.success == true && res?.data?.likes != null) {
        final newUsers = res!.data!.likes!;

        if (refresh) {
          likeUsers.value = newUsers;
        } else {
          likeUsers.addAll(newUsers);
        }

        final pagination = res.data!.pagination;
        _likePage = pagination?.currentPage ?? 1;
        _likeTotalPages = pagination?.totalPages ?? 1;
      }
    } catch (e) {
      debugPrint("Like listing error: $e");
    } finally {
      isLikeLoading.value = false;
    }
  }

  Future<void> loadMoreLikes(
      BuildContext context,
      String postSlug,
      ) async {
    if (!canLoadMoreLikes || isLikeLoading.value) return;

    _likePage++;
    await fetchLikeUsers(context, postSlug, refresh: false);
  }

  Future<bool> deletePost(BuildContext context, String postSlug) async {
    try {
      final response = await apiWorker.deletePostApi(
        DeletePostRequest(lang: LanguageController.to.apiLanguage),
        context,
        postSlug,
      );

      if (response?.success == true) {
        final removedPost = posts.firstWhereOrNull((p) => p.slug == postSlug);
        final removedPostId = removedPost?.id;

        posts.removeWhere((p) => p.slug == postSlug);
        if (removedPostId != null && removedPostId.isNotEmpty) {
          likedMap.remove(removedPostId);
          savedMap.remove(removedPostId);
          likeCountMap.remove(removedPostId);
        }
        return true;
      }
    } catch (e) {
      debugPrint('Delete post error: $e');
    }
    return false;
  }

  Future<bool> deleteStory(BuildContext context, String storyId) async {
    try {
      final response = await apiWorker.deleteStoryApi(
        DeleteStoryRequest(lang: LanguageController.to.apiLanguage),
        context,
        storyId,
      );

      if (response?.success == true) {
        final updatedUsers = storyUsers
            .map((user) {
              final updatedStories = (user.stories ?? [])
                  .where((story) => story.id != storyId)
                  .toList();
              if (updatedStories.isEmpty) return null;
              return StoryUser(
                teacherId: user.teacherId,
                teacherName: user.teacherName,
                teacherProfileLink: user.teacherProfileLink,
                stories: updatedStories,
              );
            })
            .whereType<StoryUser>()
            .toList();

        storyUsers.value = updatedUsers;
        return true;
      }
    } catch (e) {
      debugPrint('Delete story error: $e');
    }
    return false;
  }
}


