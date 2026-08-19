class TeacherGroupUserListingRequest {
  String lang;

  TeacherGroupUserListingRequest({
    required this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
    };
  }
}