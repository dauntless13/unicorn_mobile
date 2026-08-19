class HygieneResponse {
  bool? success;
  String? message;
  HygieneData? data;

  HygieneResponse({
    this.success,
    this.message,
    this.data,
  });

  factory HygieneResponse.fromJson(Map<String, dynamic> json) {
    return HygieneResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? HygieneData.fromJson(json['data']) : null,
    );
  }
}

class HygieneData {
  String? studentId;
  int? hygieneCount;
  List<HygieneItem>? hygiene;

  HygieneData({
    this.studentId,
    this.hygieneCount,
    this.hygiene,
  });

  factory HygieneData.fromJson(Map<String, dynamic> json) {
    return HygieneData(
      studentId: json['studentId'],
      hygieneCount: json['hygieneCount'],
      hygiene: (json['hygiene'] as List?)
          ?.map((e) => HygieneItem.fromJson(e))
          .toList(),
    );
  }
}

class HygieneItem {
  String? hygieneId;
  String? hygieneType;
  String? otherText;
  String? date;
  String? time;
  String? description;

  HygieneItem({
    this.hygieneId,
    this.hygieneType,
    this.otherText,
    this.date,
    this.time,
    this.description,
  });

  factory HygieneItem.fromJson(Map<String, dynamic> json) {
    String? id = json['hygieneId'];

    /// find dynamic hygiene key
    final dynamicKey = json['hygieneType'];

    return HygieneItem(
      hygieneId: id,
      hygieneType: dynamicKey,
      otherText: json['otherText'],
      date: json['date'],
      time: json['time'],
      description: json['description'],
    );
  }
}

// class HygieneDetail {
//   String? date;
//   String? time;
//   String? description;
//
//   HygieneDetail({
//     this.date,
//     this.time,
//     this.description,
//   });
//
//   factory HygieneDetail.fromJson(Map<String, dynamic> json) {
//     return HygieneDetail(
//       date: json['date'],
//       time: json['time'],
//       description: json['description'],
//     );
//   }
// }
