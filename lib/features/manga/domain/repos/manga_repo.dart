import 'package:mangadex_app/features/manga/domain/entities/chapter_list.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga_list.dart';

abstract class MangaRepo {
  Future<MangaList> searchByTitle(String title, int offset,
      {bool mostFollowed = false});
  Future<List<Manga>> getMangas(List<String> mangaIds);
  Future<ChapterList> getMangaChapters(String mangaId, int offset);
  Future<List<String>> getChapterImageUrls(String chapterId);
}
