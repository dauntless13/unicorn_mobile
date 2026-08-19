class SaveEvaluationRequest {
  final String? lang;
  final String? studentSlug;
  final String? evaluationDate;
  final String? reportingFromDate;
  final String? reportingToDate;
  final String? status;
  final String? teacherNote;
  final List<SaveEvaluationAnswer>? answers;

  SaveEvaluationRequest({
    this.lang,
    this.studentSlug,
    this.evaluationDate,
    this.reportingFromDate,
    this.reportingToDate,
    this.status,
    this.teacherNote,
    this.answers,
  });

  Map<String, dynamic> toJson() => {
        "lang": lang,
        "studentSlug": studentSlug,
        "evaluationDate": evaluationDate,
        "reportingFromDate": reportingFromDate,
        "reportingToDate": reportingToDate,
        "status": status,
        "teacherNote": teacherNote,
        "answers": answers == null
            ? []
            : List<dynamic>.from(answers!.map((x) => x.toJson())),
      };
}

class SaveEvaluationAnswer {
  final String? questionId;
  final String? rating;

  SaveEvaluationAnswer({
    this.questionId,
    this.rating,
  });

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "rating": rating,
      };
}
