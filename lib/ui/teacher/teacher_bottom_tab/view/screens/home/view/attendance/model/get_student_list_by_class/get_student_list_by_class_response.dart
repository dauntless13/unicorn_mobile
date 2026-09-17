class GetStudentListByClassResponse {
  bool? success;
  String? message;
  StudentDataByClass? data;

  GetStudentListByClassResponse({this.success, this.message, this.data});

  GetStudentListByClassResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? StudentDataByClass.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StudentDataByClass {
  String? className;
  List<Students>? students;

  StudentDataByClass({this.className, this.students});

  StudentDataByClass.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['className'] = className;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  String? name;
  String? profileLink;
  String? rollNumber;
  String? studentId;
  String? checkIn;
  String? checkOut;
  String? status;

  Students(
      {this.name,
        this.profileLink,
        this.rollNumber,
        this.studentId,
        this.checkIn,
        this.checkOut,
        this.status});

  Students.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileLink = json['profileLink'];
    rollNumber = json['rollNumber'];
    studentId = json['studentId'];
    checkIn = json['checkIn'];
    checkOut = json['checkOut'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profileLink'] = profileLink;
    data['rollNumber'] = rollNumber;
    data['studentId'] = studentId;
    data['checkIn'] = checkIn;
    data['checkOut'] = checkOut;
    data['status'] = status;
    return data;
  }
}
