import 'package:mangadex_app/features/manga/domain/entities/manga.dart';

abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Manga> mangas;

  HistoryLoaded({required this.mangas});
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError({required this.message});
}
