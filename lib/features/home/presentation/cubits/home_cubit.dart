import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_state.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final MangaRepo mangaRepo;

  HomeCubit({required this.mangaRepo}) : super(HomeLoading()) {
    fetchLatest(0);
  }

  Future<void> fetchLatest(int offset) async {
    try {
      emit(HomeLoading());
      final mangaList = await mangaRepo.searchByTitle('', offset);
      emit(HomeLoaded(mangaList: mangaList));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
