// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

FeesDetailsResponse applyForTravelTripResponseFromJson(String str) =>
    FeesDetailsResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(FeesDetailsResponse data) =>
    json.encode(data.toJson());

class FeesDetailsResponse {
  bool? success;
  String? message;
  Data? data;

  FeesDetailsResponse({
    this.success,
    this.message,
    this.data,
  });

  FeesDetailsResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      FeesDetailsResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory FeesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      FeesDetailsResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? studentName;
  String? rollNo;
  String? className;
  List<Fee>? fees;

  Data({
    this.studentName,
    this.rollNo,
    this.className,
    this.fees,
  });

  Data copyWith({
    String? studentName,
    String? rollNo,
    String? className,
    List<Fee>? fees,
  }) =>
      Data(
        studentName: studentName ?? this.studentName,
        rollNo: rollNo ?? this.rollNo,
        className: className ?? this.className,
        fees: fees ?? this.fees,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        studentName: json["studentName"],
        rollNo: json["rollNo"],
        className: json["className"],
        fees: json["fees"] == null
            ? []
            : List<Fee>.from(json["fees"]!.map((x) => Fee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "studentName": studentName,
        "rollNo": rollNo,
        "className": className,
        "fees": fees == null
            ? []
            : List<dynamic>.from(fees!.map((x) => x.toJson())),
      };
}

class Fee {
  String? id;
  String? dueDate;
  num? amount;
  String? currencyCode;
  String? symbol;
  String? installment;
  String? status;
  String? invoicePdfLink;

  Fee({
    this.id,
    this.dueDate,
    this.amount,
    this.currencyCode,
    this.symbol,
    this.installment,
    this.status,
    this.invoicePdfLink,
  });

  Fee copyWith({
    String? id,
    String? dueDate,
    num? amount,
    String? currencyCode,
    String? symbol,
    String? installment,
    String? status,
    String? invoicePdfLink,
  }) =>
      Fee(
        id: id ?? this.id,
        dueDate: dueDate ?? this.dueDate,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        symbol: symbol ?? this.symbol,
        installment: installment ?? this.installment,
        status: status ?? this.status,
        invoicePdfLink: invoicePdfLink ?? this.invoicePdfLink,
      );

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        id: json["id"],
        dueDate: json["dueDate"],
        amount: json["amount"] as num?,
        currencyCode: json["currencyCode"],
        symbol: json["symbol"],
        installment: json["installment"],
        status: json["status"],
        invoicePdfLink: json["invoicePdfLink"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dueDate": dueDate,
        "amount": amount,
        "currencyCode": currencyCode,
        "symbol": symbol,
        "installment": installment,
        "status": status,
        "invoicePdfLink": invoicePdfLink,
      };
}
