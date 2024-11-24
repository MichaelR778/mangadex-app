class Chapter {
  final String id;
  final String chapterNumber;
  final String language;

  Chapter({
    required this.id,
    required this.chapterNumber,
    required this.language,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final chapterNumber = json['attributes']['chapter'] ?? 'NaN';
    final language = json['attributes']['translatedLanguage'];

    return Chapter(
      id: id,
      chapterNumber: chapterNumber,
      language: language,
    );
  }
}
