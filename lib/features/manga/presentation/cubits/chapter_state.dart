import 'package:mangadex_app/features/manga/domain/entities/chapter_list.dart';

abstract class ChapterState {}

class ChapterLoading extends ChapterState {}

class ChapterLoaded extends ChapterState {
  final ChapterList chapterList;

  ChapterLoaded({required this.chapterList});
}

class ChapterError extends ChapterState {
  final String message;

  ChapterError({required this.message});
}
