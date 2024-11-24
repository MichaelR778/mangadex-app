import 'package:mangadex_app/features/manga/domain/entities/manga.dart';

class MangaList {
  final List<Manga> mangas;
  final int currIndex;
  final int totalPage;

  MangaList({
    required this.mangas,
    required this.currIndex,
    required this.totalPage,
  });
}
