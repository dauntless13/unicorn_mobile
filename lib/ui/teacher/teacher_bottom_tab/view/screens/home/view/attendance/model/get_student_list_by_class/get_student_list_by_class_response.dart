class GetStudentListByClassResponse {
  bool? success;
  String? message;
  StudentDataByClass? data;

  GetStudentListByClassResponse({this.success, this.message, this.data});

  GetStudentListByClassResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new StudentDataByClass.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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
        students!.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profileLink'] = this.profileLink;
    data['rollNumber'] = this.rollNumber;
    data['studentId'] = this.studentId;
    data['checkIn'] = this.checkIn;
    data['checkOut'] = this.checkOut;
    data['status'] = this.status;
    return data;
  }
}
