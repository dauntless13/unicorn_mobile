// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

StudentBySlugResponse applyForTravelTripResponseFromJson(String str) => StudentBySlugResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(StudentBySlugResponse data) => json.encode(data.toJson());

class StudentBySlugResponse {
  bool? success;
  String? message;
  StudentDataGetBySlug? data;

  StudentBySlugResponse({
    this.success,
    this.message,
    this.data,
  });

  StudentBySlugResponse copyWith({
    bool? success,
    String? message,
    StudentDataGetBySlug? data,
  }) =>
      StudentBySlugResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StudentBySlugResponse.fromJson(Map<String, dynamic> json) => StudentBySlugResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : StudentDataGetBySlug.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class StudentDataGetBySlug {
  String? studentId;
  String? studentSlug;
  String? studentCode;
  String? status;
  String? firstName;
  String? lastName;
  String? className;
  String? profileLink;
  String? rollNo;
  DateTime? dateOfBirth;
  num? feeAmount;
  String? currency;
  String? amountWithCurrency;
  String? packageDuration;
  bool? hasAllergies;
  bool? takesMedications;
  bool? hasMedicalCondition;
  bool? pickup;
  bool? medicalDecision;
  String? gender;
  DateTime? joinedOn;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? address;
  ParentProfile? parentProfile;
  EmergencyContact? emergencyContact;
  MedicalInfo? medicalInfo;

  StudentDataGetBySlug({
    this.studentId,
    this.studentSlug,
    this.studentCode,
    this.status,
    this.firstName,
    this.lastName,
    this.className,
    this.profileLink,
    this.rollNo,
    this.dateOfBirth,
    this.feeAmount,
    this.currency,
    this.amountWithCurrency,
    this.packageDuration,
    this.hasAllergies,
    this.takesMedications,
    this.hasMedicalCondition,
    this.pickup,
    this.medicalDecision,
    this.gender,
    this.joinedOn,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.address,
    this.parentProfile,
    this.emergencyContact,
    this.medicalInfo,
  });

  StudentDataGetBySlug copyWith({
    String? studentId,
    String? studentSlug,
    String? studentCode,
    String? status,
    String? firstName,
    String? lastName,
    String? className,
    String? profileLink,
    String? rollNo,
    DateTime? dateOfBirth,
    num? feeAmount,
    String? currency,
    String? amountWithCurrency,
    String? packageDuration,
    bool? hasAllergies,
    bool? takesMedications,
    bool? hasMedicalCondition,
    bool? pickup,
    bool? medicalDecision,
    String? gender,
    DateTime? joinedOn,
    String? city,
    String? state,
    String? country,
    String? zipcode,
    String? address,
    ParentProfile? parentProfile,
    EmergencyContact? emergencyContact,
    MedicalInfo? medicalInfo,
  }) =>
      StudentDataGetBySlug(
        studentId: studentId ?? this.studentId,
        studentSlug: studentSlug ?? this.studentSlug,
        studentCode: studentCode ?? this.studentCode,
        status: status ?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        className: className ?? this.className,
        profileLink: profileLink ?? this.profileLink,
        rollNo: rollNo ?? this.rollNo,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        feeAmount: feeAmount ?? this.feeAmount,
        currency: currency ?? this.currency,
        amountWithCurrency: amountWithCurrency ?? this.amountWithCurrency,
        packageDuration: packageDuration ?? this.packageDuration,
        hasAllergies: hasAllergies ?? this.hasAllergies,
        takesMedications: takesMedications ?? this.takesMedications,
        hasMedicalCondition: hasMedicalCondition ?? this.hasMedicalCondition,
        pickup: pickup ?? this.pickup,
        medicalDecision: medicalDecision ?? this.medicalDecision,
        gender: gender ?? this.gender,
        joinedOn: joinedOn ?? this.joinedOn,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        zipcode: zipcode ?? this.zipcode,
        address: address ?? this.address,
        parentProfile: parentProfile ?? this.parentProfile,
        emergencyContact: emergencyContact ?? this.emergencyContact,
        medicalInfo: medicalInfo ?? this.medicalInfo,
      );

  factory StudentDataGetBySlug.fromJson(Map<String, dynamic> json) => StudentDataGetBySlug(
    studentId: json["studentId"],
    studentSlug: json["studentSlug"],
    studentCode: json["studentCode"],
    status: json["status"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    className: json["className"],
    profileLink: json["profileLink"],
    rollNo: json["rollNo"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    feeAmount: json["feeAmount"],
    currency: json["currency"],
    amountWithCurrency: json["amountWithCurrency"],
    packageDuration: json["packageDuration"],
    hasAllergies: json["hasAllergies"],
    takesMedications: json["takesMedications"],
    hasMedicalCondition: json["hasMedicalCondition"],
    pickup: json["pickup"],
    medicalDecision: json["medicalDecision"],
    gender: json["gender"],
    joinedOn: json["joinedOn"] == null ? null : DateTime.parse(json["joinedOn"]),
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipcode: json["zipcode"],
    address: json["address"],
    parentProfile: json["parentProfile"] == null ? null : ParentProfile.fromJson(json["parentProfile"]),
    emergencyContact: json["emergencyContact"] == null ? null : EmergencyContact.fromJson(json["emergencyContact"]),
    medicalInfo: MedicalInfo.fromDynamic(json["medicalInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "studentSlug": studentSlug,
    "studentCode": studentCode,
    "status": status,
    "firstName": firstName,
    "lastName": lastName,
    "className": className,
    "profileLink": profileLink,
    "rollNo": rollNo,
    "dateOfBirth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "feeAmount": feeAmount,
    "currency": currency,
    "amountWithCurrency": amountWithCurrency,
    "packageDuration": packageDuration,
    "hasAllergies": hasAllergies,
    "takesMedications": takesMedications,
    "hasMedicalCondition": hasMedicalCondition,
    "pickup": pickup,
    "medicalDecision": medicalDecision,
    "gender": gender,
    "joinedOn": "${joinedOn!.year.toString().padLeft(4, '0')}-${joinedOn!.month.toString().padLeft(2, '0')}-${joinedOn!.day.toString().padLeft(2, '0')}",
    "city": city,
    "state": state,
    "country": country,
    "zipcode": zipcode,
    "address": address,
    "parentProfile": parentProfile?.toJson(),
    "emergencyContact": emergencyContact?.toJson(),
    "medicalInfo": medicalInfo?.toJson(),
  };
}

class EmergencyContact {
  String? firstName;
  String? lastName;
  String? email;
  String? relation;
  String? customRelationship;
  String? phoneNumber;
  String? countryCode;
  String? education;
  String? secondaryCountryCode;
  String? secondaryPhoneNumber;
  String? occupation;

  EmergencyContact({
    this.firstName,
    this.lastName,
    this.email,
    this.relation,
    this.customRelationship,
    this.phoneNumber,
    this.countryCode,
    this.education,
    this.secondaryCountryCode,
    this.secondaryPhoneNumber,
    this.occupation,
  });

  EmergencyContact copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? relation,
    String? customRelationship,
    String? phoneNumber,
    String? countryCode,
    String? education,
    String? secondaryCountryCode,
    String? secondaryPhoneNumber,
    String? occupation,
  }) =>
      EmergencyContact(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        relation: relation ?? this.relation,
        customRelationship: customRelationship ?? this.customRelationship,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        countryCode: countryCode ?? this.countryCode,
        education: education ?? this.education,
        secondaryCountryCode: secondaryCountryCode ?? this.secondaryCountryCode,
        secondaryPhoneNumber: secondaryPhoneNumber ?? this.secondaryPhoneNumber,
        occupation: occupation ?? this.occupation,
      );

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    relation: json["relation"],
    customRelationship: json["custom_relationship"],
    phoneNumber: json["phoneNumber"],
    countryCode: json["countryCode"],
    education: json["education"],
    secondaryCountryCode: json["secondaryCountryCode"],
    secondaryPhoneNumber: json["secondaryPhoneNumber"],
    occupation: json["occupation"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "relation": relation,
    "custom_relationship": customRelationship,
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "education": education,
    "secondaryCountryCode": secondaryCountryCode,
    "secondaryPhoneNumber": secondaryPhoneNumber,
    "occupation": occupation,
  };
}

class MedicalInfo {
  String? note;

  MedicalInfo({
    this.note,
  });

  MedicalInfo copyWith({
    String? note,
  }) =>
      MedicalInfo(
        note: note ?? this.note,
      );

  factory MedicalInfo.fromJson(Map<String, dynamic> json) => MedicalInfo(
     note: json["note"],
   );

  factory MedicalInfo.fromDynamic(dynamic json) {
    if (json == null) return MedicalInfo();
    if (json is MedicalInfo) return json;
    if (json is String) {
      final value = json.trim();
      return MedicalInfo(note: value.isEmpty ? null : value);
    }
    if (json is Map<String, dynamic>) {
      return MedicalInfo.fromJson(json);
    }
    if (json is Map) {
      return MedicalInfo.fromJson(Map<String, dynamic>.from(json));
    }
    return MedicalInfo(note: json.toString());
  }

  Map<String, dynamic> toJson() => {
    "note": note,
  };
}

class ParentProfile {
  String? firstName;
  String? lastName;
  String? email;
  String? profileLink;
  String? address;
  String? education;
  String? relationship;
  String? countryCode;
  String? phoneNumber;
  String? occupation;

  ParentProfile({
    this.firstName,
    this.lastName,
    this.email,
    this.profileLink,
    this.address,
    this.education,
    this.relationship,
    this.countryCode,
    this.phoneNumber,
    this.occupation,
  });

  ParentProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profileLink,
    String? address,
    String? education,
    String? relationship,
    String? countryCode,
    String? phoneNumber,
    String? occupation,
  }) =>
      ParentProfile(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        profileLink: profileLink ?? this.profileLink,
        address: address ?? this.address,
        education: education ?? this.education,
        relationship: relationship ?? this.relationship,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        occupation: occupation ?? this.occupation,
      );

  factory ParentProfile.fromJson(Map<String, dynamic> json) => ParentProfile(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    profileLink: json["profileLink"],
    address: json["address"],
    education: json["education"],
    relationship: json["relationship"],
    countryCode: json["countryCode"],
    phoneNumber: json["phoneNumber"],
    occupation: json["occupation"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "profileLink": profileLink,
    "address": address,
    "education": education,
    "relationship": relationship,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "occupation": occupation,
  };
}
