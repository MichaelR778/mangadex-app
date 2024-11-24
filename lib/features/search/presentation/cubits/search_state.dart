import 'package:mangadex_app/features/manga/domain/entities/manga_list.dart';

abstract class SearchState {}

// class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final MangaList mangaList;

  SearchLoaded({required this.mangaList});
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
