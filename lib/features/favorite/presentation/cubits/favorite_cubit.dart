import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/favorite/domain/repos/favorite_repo.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_state.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo favoriteRepo;
  final MangaRepo mangaRepo;
  StreamSubscription? favoriteSubscription;

  FavoriteCubit({
    required this.favoriteRepo,
    required this.mangaRepo,
  }) : super(FavoriteLoading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      // emit(FavoriteLoading());

      favoriteSubscription?.cancel();

      favoriteSubscription = favoriteRepo.getFavorites().listen(
        (mangaIds) async {
          if (mangaIds.isEmpty) {
            emit(FavoriteLoaded(mangaIds: mangaIds, mangas: []));
            return;
          }
          final mangas = await mangaRepo.getMangas(mangaIds);
          emit(FavoriteLoaded(mangaIds: mangaIds, mangas: mangas));
        },
        onError: (error) {
          emit(FavoriteError(message: error.toString()));
        },
      );
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> toggleFavorite(String mangaId) async {
    try {
      await favoriteRepo.toggleFavorite(mangaId);
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
      loadFavorites();
    }
  }
}
