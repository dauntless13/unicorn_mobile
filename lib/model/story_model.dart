
class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String imageUrl; // can be network or local file path
  final bool isMine;
  final DateTime createdAt;
  final bool isLive;

  StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.imageUrl,
    this.isMine = false,
    required this.createdAt,
    this.isLive = false,
  });
}