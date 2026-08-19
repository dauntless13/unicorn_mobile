class UpdateParentProfileRequest {
  final String firstName;
  final String lastName;
  final String address;
  final String countryCode;
  final String phoneNumber;
  final String profileLink;
  final String relationship; // FATHER, MOTHER, GUARDIAN
  final String education;
  final String occupation;
  final String lang; // EN or AR

  UpdateParentProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.countryCode,
    required this.phoneNumber,
    required this.profileLink,
    required this.relationship,
    required this.education,
    required this.occupation,
    this.lang = "EN",
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "address": address,
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "profileLink": profileLink,
      "relationship": relationship,
      "education": education,
      "occupation": occupation,
      "lang": lang,
    };
  }
}