class Manga {
  final String id;
  final String coverUrl;
  final String title;
  final List<String> tags;
  final String description;

  Manga({
    required this.id,
    required this.coverUrl,
    required this.title,
    required this.tags,
    required this.description,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    // manga id
    final id = json['id'];

    // cover filename
    String fileName = '';
    final List<dynamic> relationships = json['relationships'];
    for (final relation in relationships) {
      if (relation['type'] == 'cover_art') {
        fileName = relation['attributes']['fileName'];
      }
    }

    final attributes = json['attributes'];

    // title
    String title = 'No title found';
    try {
      List<dynamic> altTitles = attributes['altTitles'];
      title = attributes['title']['en'] ??
          altTitles
              .firstWhere((json) => json.keys.first == 'en')
              .values
              .first ??
          altTitles
              .firstWhere((json) => json.keys.first == 'ja-ro')
              .values
              .first ??
          altTitles
              .firstWhere((json) => json.keys.first == 'ko-ro')
              .values
              .first;
    } catch (e) {}

    // tags
    final List<dynamic> tags = attributes['tags'];
    final List<String> tagStrings = [];
    for (final tag in tags) {
      tagStrings.add(tag['attributes']['name']['en']);
    }

    // desc
    final String desc = attributes['description']['en'] ?? 'No en desc found';

    return Manga(
      id: id,
      coverUrl: 'https://uploads.mangadex.org/covers/$id/$fileName.512.jpg',
      title: title,
      tags: tagStrings,
      description: desc,
    );
  }
}
