import 'package:get/get.dart';

import '../../../../../../../model/post_model.dart';
import '../../../../../../../model/story_model.dart';

class HomeScreenController extends GetxController {
  /// STORIES LIST
  RxList<StoryModel> stories = <StoryModel>[].obs;

  /// POSTS LIST (FEED)
  RxList<PostModel> posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStories();
    loadPosts();
  }

  /// LOAD DUMMY STORIES (Replace with API later)
  void loadStories() {
    stories.value = [
      StoryModel(
        id: '1',
        username: 'Your Story',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        imageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=1200',
        isMine: true,
        createdAt: DateTime.now(),
      ),
      StoryModel(
        id: '2',
        username: 'karennne',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        imageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=1200',
        isLive: true,
        createdAt: DateTime.now().subtract(Duration(minutes: 1)),
      ),
      StoryModel(
        id: '3',
        username: 'zackjohn',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=1200',
        createdAt: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      StoryModel(
        id: '4',
        username: 'craig',
        avatarUrl:
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200',
        imageUrl:
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=1200',
        createdAt: DateTime.now().subtract(Duration(minutes: 10)),
      ),
      StoryModel(
        id: '5',
        username: 'kieron_d',
        avatarUrl:
            'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=200',
        imageUrl:
            'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=1200',
        createdAt: DateTime.now().subtract(Duration(minutes: 15)),
      ),
    ];
  }

  /// LOAD DUMMY POSTS (Replace with API later)
  void loadPosts() {
    posts.value = [
      PostModel(
        username: 'kids_world',
        location: 'Tokyo, Japan',
        avatar:
            'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=200',
        images: [
          'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=1200',
          // kids playing
          'https://images.unsplash.com/photo-1503455637927-730bce8583c0?w=1200',
          // child smiling
        ],
        likesText: 'Liked by mom_life and 2343 others',
        caption: 'happy kids time',
        date: 'September 19',
        shareLink: 'https://zacoto.example/post/kids_world/2025-09-19/1',
      ),
      PostModel(
        username: 'little_stars',
        location: 'Los Angeles, USA',
        avatar:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
        images: [
          'https://images.unsplash.com/photo-1504151932400-72d4384f04b3?w=1200',
          // baby
          'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=1200',
          // kids laughing
        ],
        likesText: 'Liked by family_fun and 1200 others',
        caption: 'smiles everywhere 😊',
        date: 'August 10',
        shareLink: 'https://zacoto.example/post/little_stars/2025-08-10',
      ),
      PostModel(
        username: 'kids_play',
        location: 'Berlin, Germany',
        avatar:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        images: [
          'https://images.unsplash.com/photo-1502784444187-359ac186c5bb?w=1200',
          // playground
          'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1200',
          // school kids
        ],
        likesText: 'Liked by dad_life and 512 others',
        caption: 'playground fun',
        date: 'July 2',
        shareLink: 'https://zacoto.example/post/kids_play/2025-07-02',
      ),
      PostModel(
        username: 'baby_smiles',
        location: 'Milan, Italy',
        avatar:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
        images: [
          'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=1200',
        ],
        likesText: 'Liked by happy_mom and 987 others',
        caption: 'cute moments 💖',
        date: 'June 30',
        shareLink: 'https://zacoto.example/post/baby_smiles/2025-06-30',
      ),
      PostModel(
        username: 'kids_fun',
        location: 'London, UK',
        avatar:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        images: [
          'https://images.unsplash.com/photo-1519340333755-56e9c3d3d4ad?w=1200',
          'https://images.unsplash.com/photo-1503455637927-730bce8583c0?w=1200',
        ],
        likesText: 'Liked by jack and 342 others',
        caption: 'fun day out',
        date: 'May 12',
        shareLink: 'https://zacoto.example/post/kids_fun/2025-05-12',
      ),
    ];
  }

  void addStory(StoryModel story) {
    stories.insert(0, story);
  }

  void removeExpiredStories() {
    stories.removeWhere(
      (s) => DateTime.now().difference(s.createdAt).inHours >= 24,
    );
  }

  Map<String, List<StoryModel>> get groupedStories {
    final Map<String, List<StoryModel>> map = {};

    for (final story in stories) {
      map.putIfAbsent(story.username, () => []);
      map[story.username]!.add(story);
    }

    return map;
  }
}
