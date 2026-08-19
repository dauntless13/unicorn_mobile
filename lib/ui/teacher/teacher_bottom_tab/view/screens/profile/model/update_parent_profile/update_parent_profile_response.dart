/// success : true
/// message : "Nursery listed successfully"
/// data : {"id":"218282d1-e289-416d-947c-4fe120203ca3","role":"PARENT","firstName":"John","lastName":"Smith","countryCode":"+677","phoneNumber":"","address":"","profileLink":"","relationship":"FATHER","education":"fvggb","occupation":""}

class UpdateParentProfileResponse {
  UpdateParentProfileResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  UpdateParentProfileResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
UpdateParentProfileResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => UpdateParentProfileResponse(  success: success ?? _success,
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

/// id : "218282d1-e289-416d-947c-4fe120203ca3"
/// role : "PARENT"
/// firstName : "John"
/// lastName : "Smith"
/// countryCode : "+677"
/// phoneNumber : ""
/// address : ""
/// profileLink : ""
/// relationship : "FATHER"
/// education : "fvggb"
/// occupation : ""

class Data {
  Data({
      String? id, 
      String? role, 
      String? firstName, 
      String? lastName, 
      String? countryCode, 
      String? phoneNumber, 
      String? address, 
      String? profileLink, 
      String? relationship, 
      String? education, 
      String? occupation,}){
    _id = id;
    _role = role;
    _firstName = firstName;
    _lastName = lastName;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _address = address;
    _profileLink = profileLink;
    _relationship = relationship;
    _education = education;
    _occupation = occupation;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _role = json['role'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _countryCode = json['countryCode'];
    _phoneNumber = json['phoneNumber'];
    _address = json['address'];
    _profileLink = json['profileLink'];
    _relationship = json['relationship'];
    _education = json['education'];
    _occupation = json['occupation'];
  }
  String? _id;
  String? _role;
  String? _firstName;
  String? _lastName;
  String? _countryCode;
  String? _phoneNumber;
  String? _address;
  String? _profileLink;
  String? _relationship;
  String? _education;
  String? _occupation;
Data copyWith({  String? id,
  String? role,
  String? firstName,
  String? lastName,
  String? countryCode,
  String? phoneNumber,
  String? address,
  String? profileLink,
  String? relationship,
  String? education,
  String? occupation,
}) => Data(  id: id ?? _id,
  role: role ?? _role,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  countryCode: countryCode ?? _countryCode,
  phoneNumber: phoneNumber ?? _phoneNumber,
  address: address ?? _address,
  profileLink: profileLink ?? _profileLink,
  relationship: relationship ?? _relationship,
  education: education ?? _education,
  occupation: occupation ?? _occupation,
);
  String? get id => _id;
  String? get role => _role;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get countryCode => _countryCode;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get profileLink => _profileLink;
  String? get relationship => _relationship;
  String? get education => _education;
  String? get occupation => _occupation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['role'] = _role;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['countryCode'] = _countryCode;
    map['phoneNumber'] = _phoneNumber;
    map['address'] = _address;
    map['profileLink'] = _profileLink;
    map['relationship'] = _relationship;
    map['education'] = _education;
    map['occupation'] = _occupation;
    return map;
  }

}