import 'package:mangadex_app/features/manga/domain/entities/chapter.dart';

class ChapterList {
  final List<Chapter> chapters;
  final int currIndex;
  final int totalPage;

  ChapterList({
    required this.chapters,
    required this.currIndex,
    required this.totalPage,
  });
}
