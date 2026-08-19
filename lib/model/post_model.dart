
class PostModel {
  final String username;
  final String location;
  final String avatar;
  final List<String> images;
  final String likesText;
  final String caption;
  final String date;

  /// Optional share link used by the share sheet.
  final String? shareLink;

  PostModel({
    required this.username,
    required this.location,
    required this.avatar,
    required this.images,
    required this.likesText,
    required this.caption,
    required this.date,
    this.shareLink,
  });
}