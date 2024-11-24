import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MangaRepo mangaRepo;
  String lastSearch = '';
  bool orderByFollow = true;

  SearchCubit({required this.mangaRepo}) : super(SearchLoading()) {
    searchByTitle('', 0, mostFollowed: true);
  }

  Future<void> searchByTitle(String title, int offset,
      {bool mostFollowed = false}) async {
    try {
      emit(SearchLoading());
      lastSearch = title;
      orderByFollow = mostFollowed;
      final mangaList = await mangaRepo.searchByTitle(
        title,
        offset,
        mostFollowed: mostFollowed,
      );
      emit(SearchLoaded(mangaList: mangaList));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
