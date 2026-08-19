class UpdateTeacherProfileRequest {
  final String firstName;
  final String lastName;
  final String education;
  final String subject;
  final int experience;
  final String countryCode;
  final String phoneNumber;
  final String address;
  final String countryId;
  final String stateId;
  final String cityId;
  final String zipCode;
  final String profileLink;
  final List<String> classIds;
  final String lang;

  UpdateTeacherProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.education,
    required this.subject,
    required this.experience,
    required this.countryCode,
    required this.phoneNumber,
    required this.address,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.zipCode,
    required this.profileLink,
    required this.classIds,
    required this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "education": education,
      "subject": subject,
      "experience": experience,
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "address": address,
      "countryId": countryId,
      "stateId": stateId,
      "cityId": cityId,
      "zipCode": zipCode,
      "profileLink": profileLink,
      "classIds": classIds,
      "lang": lang,
    };
  }
}