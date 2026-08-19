/// success : true
/// message : "Student updated successfully"
/// data : {"student":{"id":"88dbe73c-219d-46ef-a45b-46b9fbf3899d","studentCode":"AD0000020","rollNumber":"0020","firstName":"              Kabir ","lastName":"    Kumar","address":"Ahmedabad, Gujarat, India","medicalInfo":"","zipCode":"380001","gender":"MALE","dateOfBirth":"2026-02-05","joinDate":"2026-02-20","countryId":"f126b559-4e99-46bd-91aa-3a9a34a2ed81","stateId":"6c2d9685-cfb7-4273-8530-984da4711ffd","cityId":"70700e96-c014-4c05-ac08-6dd34f5f29ed","currency":"INR","feeAmount":53,"feeAmountWithCurrency":"INR 53","packageDuration":"THREE_MONTH","hasAllergies":false,"takesMedications":false,"hasMedicalCondition":false,"pickup":false,"medicalDecision":false,"photoUrl":"","slug":"student-kabir-kumar-AD0000020"},"parent":{"id":"1170998a-4a66-49ae-87dd-db02db43c767","firstName":"Anaya ","lastName":"Singh 412","profileLink":"","relationship":"MOTHER","education":"graduation","occupation":"business","countryCode":"+974","phoneNumber":"54655550","email":"anaya@gmail.com"},"emergencyContact":{"id":"10522954-1829-4627-84ed-ace7a2e70417","firstName":"Kiara ","lastName":"Iyer","relationship":"MOTHER","custom_relationship":"","education":"","occupation":"","countryCode":"+974","phoneNumber":"90641255","secondaryPhoneNumber":"","email":"kiara@gmail.com"}}

class UpdateStudentDetailsResponse {
  UpdateStudentDetailsResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  UpdateStudentDetailsResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
UpdateStudentDetailsResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => UpdateStudentDetailsResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// student : {"id":"88dbe73c-219d-46ef-a45b-46b9fbf3899d","studentCode":"AD0000020","rollNumber":"0020","firstName":"              Kabir ","lastName":"    Kumar","address":"Ahmedabad, Gujarat, India","medicalInfo":"","zipCode":"380001","gender":"MALE","dateOfBirth":"2026-02-05","joinDate":"2026-02-20","countryId":"f126b559-4e99-46bd-91aa-3a9a34a2ed81","stateId":"6c2d9685-cfb7-4273-8530-984da4711ffd","cityId":"70700e96-c014-4c05-ac08-6dd34f5f29ed","currency":"INR","feeAmount":53,"feeAmountWithCurrency":"INR 53","packageDuration":"THREE_MONTH","hasAllergies":false,"takesMedications":false,"hasMedicalCondition":false,"pickup":false,"medicalDecision":false,"photoUrl":"","slug":"student-kabir-kumar-AD0000020"}
/// parent : {"id":"1170998a-4a66-49ae-87dd-db02db43c767","firstName":"Anaya ","lastName":"Singh 412","profileLink":"","relationship":"MOTHER","education":"graduation","occupation":"business","countryCode":"+974","phoneNumber":"54655550","email":"anaya@gmail.com"}
/// emergencyContact : {"id":"10522954-1829-4627-84ed-ace7a2e70417","firstName":"Kiara ","lastName":"Iyer","relationship":"MOTHER","custom_relationship":"","education":"","occupation":"","countryCode":"+974","phoneNumber":"90641255","secondaryPhoneNumber":"","email":"kiara@gmail.com"}

class Data {
  Data({
      Student? student, 
      Parent? parent, 
      EmergencyContact? emergencyContact,}){
    _student = student;
    _parent = parent;
    _emergencyContact = emergencyContact;
}

  Data.fromJson(dynamic json) {
    _student = json['student'] != null ? Student.fromJson(json['student']) : null;
    _parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
    _emergencyContact = json['emergencyContact'] != null ? EmergencyContact.fromJson(json['emergencyContact']) : null;
  }
  Student? _student;
  Parent? _parent;
  EmergencyContact? _emergencyContact;
Data copyWith({  Student? student,
  Parent? parent,
  EmergencyContact? emergencyContact,
}) => Data(  student: student ?? _student,
  parent: parent ?? _parent,
  emergencyContact: emergencyContact ?? _emergencyContact,
);
  Student? get student => _student;
  Parent? get parent => _parent;
  EmergencyContact? get emergencyContact => _emergencyContact;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_student != null) {
      map['student'] = _student?.toJson();
    }
    if (_parent != null) {
      map['parent'] = _parent?.toJson();
    }
    if (_emergencyContact != null) {
      map['emergencyContact'] = _emergencyContact?.toJson();
    }
    return map;
  }

}

/// id : "10522954-1829-4627-84ed-ace7a2e70417"
/// firstName : "Kiara "
/// lastName : "Iyer"
/// relationship : "MOTHER"
/// custom_relationship : ""
/// education : ""
/// occupation : ""
/// countryCode : "+974"
/// phoneNumber : "90641255"
/// secondaryPhoneNumber : ""
/// email : "kiara@gmail.com"

class EmergencyContact {
  EmergencyContact({
      String? id, 
      String? firstName, 
      String? lastName, 
      String? relationship, 
      String? customRelationship, 
      String? education, 
      String? occupation, 
      String? countryCode, 
      String? phoneNumber, 
      String? secondaryPhoneNumber, 
      String? email,}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _relationship = relationship;
    _customRelationship = customRelationship;
    _education = education;
    _occupation = occupation;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _secondaryPhoneNumber = secondaryPhoneNumber;
    _email = email;
}

  EmergencyContact.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _relationship = json['relationship'];
    _customRelationship = json['custom_relationship'];
    _education = json['education'];
    _occupation = json['occupation'];
    _countryCode = json['countryCode'];
    _phoneNumber = json['phoneNumber'];
    _secondaryPhoneNumber = json['secondaryPhoneNumber'];
    _email = json['email'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _relationship;
  String? _customRelationship;
  String? _education;
  String? _occupation;
  String? _countryCode;
  String? _phoneNumber;
  String? _secondaryPhoneNumber;
  String? _email;
EmergencyContact copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? relationship,
  String? customRelationship,
  String? education,
  String? occupation,
  String? countryCode,
  String? phoneNumber,
  String? secondaryPhoneNumber,
  String? email,
}) => EmergencyContact(  id: id ?? _id,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  relationship: relationship ?? _relationship,
  customRelationship: customRelationship ?? _customRelationship,
  education: education ?? _education,
  occupation: occupation ?? _occupation,
  countryCode: countryCode ?? _countryCode,
  phoneNumber: phoneNumber ?? _phoneNumber,
  secondaryPhoneNumber: secondaryPhoneNumber ?? _secondaryPhoneNumber,
  email: email ?? _email,
);
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get relationship => _relationship;
  String? get customRelationship => _customRelationship;
  String? get education => _education;
  String? get occupation => _occupation;
  String? get countryCode => _countryCode;
  String? get phoneNumber => _phoneNumber;
  String? get secondaryPhoneNumber => _secondaryPhoneNumber;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['relationship'] = _relationship;
    map['custom_relationship'] = _customRelationship;
    map['education'] = _education;
    map['occupation'] = _occupation;
    map['countryCode'] = _countryCode;
    map['phoneNumber'] = _phoneNumber;
    map['secondaryPhoneNumber'] = _secondaryPhoneNumber;
    map['email'] = _email;
    return map;
  }

}

/// id : "1170998a-4a66-49ae-87dd-db02db43c767"
/// firstName : "Anaya "
/// lastName : "Singh 412"
/// profileLink : ""
/// relationship : "MOTHER"
/// education : "graduation"
/// occupation : "business"
/// countryCode : "+974"
/// phoneNumber : "54655550"
/// email : "anaya@gmail.com"

class Parent {
  Parent({
      String? id, 
      String? firstName, 
      String? lastName, 
      String? profileLink, 
      String? relationship, 
      String? education, 
      String? occupation, 
      String? countryCode, 
      String? phoneNumber, 
      String? email,}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _profileLink = profileLink;
    _relationship = relationship;
    _education = education;
    _occupation = occupation;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _email = email;
}

  Parent.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _profileLink = json['profileLink'];
    _relationship = json['relationship'];
    _education = json['education'];
    _occupation = json['occupation'];
    _countryCode = json['countryCode'];
    _phoneNumber = json['phoneNumber'];
    _email = json['email'];
  }
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _profileLink;
  String? _relationship;
  String? _education;
  String? _occupation;
  String? _countryCode;
  String? _phoneNumber;
  String? _email;
Parent copyWith({  String? id,
  String? firstName,
  String? lastName,
  String? profileLink,
  String? relationship,
  String? education,
  String? occupation,
  String? countryCode,
  String? phoneNumber,
  String? email,
}) => Parent(  id: id ?? _id,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  profileLink: profileLink ?? _profileLink,
  relationship: relationship ?? _relationship,
  education: education ?? _education,
  occupation: occupation ?? _occupation,
  countryCode: countryCode ?? _countryCode,
  phoneNumber: phoneNumber ?? _phoneNumber,
  email: email ?? _email,
);
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get profileLink => _profileLink;
  String? get relationship => _relationship;
  String? get education => _education;
  String? get occupation => _occupation;
  String? get countryCode => _countryCode;
  String? get phoneNumber => _phoneNumber;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['profileLink'] = _profileLink;
    map['relationship'] = _relationship;
    map['education'] = _education;
    map['occupation'] = _occupation;
    map['countryCode'] = _countryCode;
    map['phoneNumber'] = _phoneNumber;
    map['email'] = _email;
    return map;
  }

}

/// id : "88dbe73c-219d-46ef-a45b-46b9fbf3899d"
/// studentCode : "AD0000020"
/// rollNumber : "0020"
/// firstName : "              Kabir "
/// lastName : "    Kumar"
/// address : "Ahmedabad, Gujarat, India"
/// medicalInfo : ""
/// zipCode : "380001"
/// gender : "MALE"
/// dateOfBirth : "2026-02-05"
/// joinDate : "2026-02-20"
/// countryId : "f126b559-4e99-46bd-91aa-3a9a34a2ed81"
/// stateId : "6c2d9685-cfb7-4273-8530-984da4711ffd"
/// cityId : "70700e96-c014-4c05-ac08-6dd34f5f29ed"
/// currency : "INR"
/// feeAmount : 53
/// feeAmountWithCurrency : "INR 53"
/// packageDuration : "THREE_MONTH"
/// hasAllergies : false
/// takesMedications : false
/// hasMedicalCondition : false
/// pickup : false
/// medicalDecision : false
/// photoUrl : ""
/// slug : "student-kabir-kumar-AD0000020"

class Student {
  Student({
      String? id, 
      String? studentCode, 
      String? rollNumber, 
      String? firstName, 
      String? lastName, 
      String? address, 
      String? medicalInfo, 
      String? zipCode, 
      String? gender, 
      String? dateOfBirth, 
      String? joinDate, 
      String? countryId, 
      String? stateId, 
      String? cityId, 
      String? currency, 
      num? feeAmount, 
      String? feeAmountWithCurrency, 
      String? packageDuration, 
      bool? hasAllergies, 
      bool? takesMedications, 
      bool? hasMedicalCondition, 
      bool? pickup, 
      bool? medicalDecision, 
      String? photoUrl, 
      String? slug,}){
    _id = id;
    _studentCode = studentCode;
    _rollNumber = rollNumber;
    _firstName = firstName;
    _lastName = lastName;
    _address = address;
    _medicalInfo = medicalInfo;
    _zipCode = zipCode;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _joinDate = joinDate;
    _countryId = countryId;
    _stateId = stateId;
    _cityId = cityId;
    _currency = currency;
    _feeAmount = feeAmount;
    _feeAmountWithCurrency = feeAmountWithCurrency;
    _packageDuration = packageDuration;
    _hasAllergies = hasAllergies;
    _takesMedications = takesMedications;
    _hasMedicalCondition = hasMedicalCondition;
    _pickup = pickup;
    _medicalDecision = medicalDecision;
    _photoUrl = photoUrl;
    _slug = slug;
}

  Student.fromJson(dynamic json) {
    _id = json['id'];
    _studentCode = json['studentCode'];
    _rollNumber = json['rollNumber'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _address = json['address'];
    _medicalInfo = json['medicalInfo'];
    _zipCode = json['zipCode'];
    _gender = json['gender'];
    _dateOfBirth = json['dateOfBirth'];
    _joinDate = json['joinDate'];
    _countryId = json['countryId'];
    _stateId = json['stateId'];
    _cityId = json['cityId'];
    _currency = json['currency'];
    _feeAmount = json['feeAmount'];
    _feeAmountWithCurrency = json['feeAmountWithCurrency'];
    _packageDuration = json['packageDuration'];
    _hasAllergies = json['hasAllergies'];
    _takesMedications = json['takesMedications'];
    _hasMedicalCondition = json['hasMedicalCondition'];
    _pickup = json['pickup'];
    _medicalDecision = json['medicalDecision'];
    _photoUrl = json['photoUrl'];
    _slug = json['slug'];
  }
  String? _id;
  String? _studentCode;
  String? _rollNumber;
  String? _firstName;
  String? _lastName;
  String? _address;
  String? _medicalInfo;
  String? _zipCode;
  String? _gender;
  String? _dateOfBirth;
  String? _joinDate;
  String? _countryId;
  String? _stateId;
  String? _cityId;
  String? _currency;
  num? _feeAmount;
  String? _feeAmountWithCurrency;
  String? _packageDuration;
  bool? _hasAllergies;
  bool? _takesMedications;
  bool? _hasMedicalCondition;
  bool? _pickup;
  bool? _medicalDecision;
  String? _photoUrl;
  String? _slug;
Student copyWith({  String? id,
  String? studentCode,
  String? rollNumber,
  String? firstName,
  String? lastName,
  String? address,
  String? medicalInfo,
  String? zipCode,
  String? gender,
  String? dateOfBirth,
  String? joinDate,
  String? countryId,
  String? stateId,
  String? cityId,
  String? currency,
  num? feeAmount,
  String? feeAmountWithCurrency,
  String? packageDuration,
  bool? hasAllergies,
  bool? takesMedications,
  bool? hasMedicalCondition,
  bool? pickup,
  bool? medicalDecision,
  String? photoUrl,
  String? slug,
}) => Student(  id: id ?? _id,
  studentCode: studentCode ?? _studentCode,
  rollNumber: rollNumber ?? _rollNumber,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  address: address ?? _address,
  medicalInfo: medicalInfo ?? _medicalInfo,
  zipCode: zipCode ?? _zipCode,
  gender: gender ?? _gender,
  dateOfBirth: dateOfBirth ?? _dateOfBirth,
  joinDate: joinDate ?? _joinDate,
  countryId: countryId ?? _countryId,
  stateId: stateId ?? _stateId,
  cityId: cityId ?? _cityId,
  currency: currency ?? _currency,
  feeAmount: feeAmount ?? _feeAmount,
  feeAmountWithCurrency: feeAmountWithCurrency ?? _feeAmountWithCurrency,
  packageDuration: packageDuration ?? _packageDuration,
  hasAllergies: hasAllergies ?? _hasAllergies,
  takesMedications: takesMedications ?? _takesMedications,
  hasMedicalCondition: hasMedicalCondition ?? _hasMedicalCondition,
  pickup: pickup ?? _pickup,
  medicalDecision: medicalDecision ?? _medicalDecision,
  photoUrl: photoUrl ?? _photoUrl,
  slug: slug ?? _slug,
);
  String? get id => _id;
  String? get studentCode => _studentCode;
  String? get rollNumber => _rollNumber;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get address => _address;
  String? get medicalInfo => _medicalInfo;
  String? get zipCode => _zipCode;
  String? get gender => _gender;
  String? get dateOfBirth => _dateOfBirth;
  String? get joinDate => _joinDate;
  String? get countryId => _countryId;
  String? get stateId => _stateId;
  String? get cityId => _cityId;
  String? get currency => _currency;
  num? get feeAmount => _feeAmount;
  String? get feeAmountWithCurrency => _feeAmountWithCurrency;
  String? get packageDuration => _packageDuration;
  bool? get hasAllergies => _hasAllergies;
  bool? get takesMedications => _takesMedications;
  bool? get hasMedicalCondition => _hasMedicalCondition;
  bool? get pickup => _pickup;
  bool? get medicalDecision => _medicalDecision;
  String? get photoUrl => _photoUrl;
  String? get slug => _slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['studentCode'] = _studentCode;
    map['rollNumber'] = _rollNumber;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['address'] = _address;
    map['medicalInfo'] = _medicalInfo;
    map['zipCode'] = _zipCode;
    map['gender'] = _gender;
    map['dateOfBirth'] = _dateOfBirth;
    map['joinDate'] = _joinDate;
    map['countryId'] = _countryId;
    map['stateId'] = _stateId;
    map['cityId'] = _cityId;
    map['currency'] = _currency;
    map['feeAmount'] = _feeAmount;
    map['feeAmountWithCurrency'] = _feeAmountWithCurrency;
    map['packageDuration'] = _packageDuration;
    map['hasAllergies'] = _hasAllergies;
    map['takesMedications'] = _takesMedications;
    map['hasMedicalCondition'] = _hasMedicalCondition;
    map['pickup'] = _pickup;
    map['medicalDecision'] = _medicalDecision;
    map['photoUrl'] = _photoUrl;
    map['slug'] = _slug;
    return map;
  }

}