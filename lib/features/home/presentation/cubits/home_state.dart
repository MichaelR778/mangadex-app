import 'package:mangadex_app/features/manga/domain/entities/manga_list.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MangaList mangaList;

  HomeLoaded({required this.mangaList});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
