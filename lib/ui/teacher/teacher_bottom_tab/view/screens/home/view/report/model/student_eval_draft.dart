class StudentEvalDraft {
  StudentEvalDraft(this.slug);

  final String slug;
  String? existingId;
  String status = '';
  bool hadExisting = false;
  bool locked = false;
  bool answersLoaded = false;

  final Map<String, String> answers = {};
  final Map<String, String> originalAnswers = {};

  int get answeredCount =>
      answers.values.where((value) => value.trim().isNotEmpty).length;

  bool isComplete(int totalQuestions) =>
      totalQuestions > 0 && answeredCount >= totalQuestions;

  bool get isDirty {
    if (answers.length != originalAnswers.length) return true;
    for (final entry in answers.entries) {
      if (originalAnswers[entry.key] != entry.value) return true;
    }
    return originalAnswers.keys.any((key) => !answers.containsKey(key));
  }

  void setOriginalFromCurrent() {
    originalAnswers
      ..clear()
      ..addAll(answers);
  }
}
