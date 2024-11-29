import 'package:mangadex_app/features/manga/domain/entities/manga.dart';

abstract class FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<String> mangaIds;
  final List<Manga> mangas;

  FavoriteLoaded({required this.mangaIds, required this.mangas});
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});
}
