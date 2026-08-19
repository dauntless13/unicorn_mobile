class UpdateStudentDetailsRequest {
  String? lang;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? address;
  String? gender;
  String? dateOfBirth;
  String? countryId;
  String? stateId;
  String? cityId;
  String? zipCode;
  String? classId;
  String? currency;
  num? feeAmount;
  String? packageDuration;
  bool? hasAllergies;
  bool? takesMedications;
  bool? hasMedicalCondition;
  bool? pickup;
  bool? medicalDecision;
  ParentRequest? parent;
  EmergencyRequest? emergency;

  UpdateStudentDetailsRequest({
    this.lang,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.countryId,
    this.stateId,
    this.cityId,
    this.zipCode,
    this.classId,
    this.currency,
    this.feeAmount,
    this.packageDuration,
    this.hasAllergies,
    this.takesMedications,
    this.hasMedicalCondition,
    this.pickup,
    this.medicalDecision,
    this.parent,
    this.emergency,
  });

  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "firstName": firstName?.trim(),
      "lastName": lastName?.trim(),
      "profileLink": profileLink ?? "",
      "address": address,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "countryId": countryId,
      "stateId": stateId,
      "cityId": cityId,
      "zipCode": zipCode,
      "classId": classId,
      "currency": currency,
      "feeAmount": feeAmount,
      "packageDuration": packageDuration,
      "hasAllergies": hasAllergies,
      "takesMedications": takesMedications,
      "hasMedicalCondition": hasMedicalCondition,
      "pickup": pickup,
      "medicalDecision": medicalDecision,
      "parent": parent?.toJson(),
      "emergency": emergency?.toJson(),
    };
  }
}

class ParentRequest {
  String? relationship;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? address;
  String? phoneNumber;
  String? countryCode;
  String? education;
  String? occupation;

  ParentRequest({
    this.relationship,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.address,
    this.phoneNumber,
    this.countryCode,
    this.education,
    this.occupation,
  });

  Map<String, dynamic> toJson() {
    return {
      "relationship": relationship,
      "firstName": firstName?.trim(),
      "lastName": lastName?.trim(),
      "profileLink": profileLink ?? "",
      "address": address,
      "phoneNumber": phoneNumber,
      "countryCode": countryCode,
      "education": education,
      "occupation": occupation,
    };
  }
}

class EmergencyRequest {
  String? firstName;
  String? lastName;
  String? emailAddress;
  String? phoneNumber;
  String? countryCode;
  String? secondaryPhoneNumber;
  String? secondaryCountryCode;
  String? relationship;
  String? customRelationship;
  String? education;
  String? occupation;

  EmergencyRequest({
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.phoneNumber,
    this.countryCode,
    this.secondaryPhoneNumber,
    this.secondaryCountryCode,
    this.relationship,
    this.customRelationship,
    this.education,
    this.occupation,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName?.trim(),
      "lastName": lastName?.trim(),
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber,
      "countryCode": countryCode,
      "secondaryPhoneNumber": secondaryPhoneNumber,
      "secondaryCountryCode": secondaryCountryCode,
      "relationship": relationship?.trim(),
      "custom_relationship": customRelationship?.trim() ?? "",
      "education": education,
      "occupation": occupation,
    };
  }
}
