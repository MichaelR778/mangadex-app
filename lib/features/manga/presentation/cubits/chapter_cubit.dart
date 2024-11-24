import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  final MangaRepo mangaRepo;

  ChapterCubit({required this.mangaRepo}) : super(ChapterLoading());

  Future<void> getMangaChapters(String mangaId, int offset) async {
    try {
      emit(ChapterLoading());
      final chapterList = await mangaRepo.getMangaChapters(mangaId, offset);
      emit(ChapterLoaded(chapterList: chapterList));
    } catch (e) {
      emit(ChapterError(message: e.toString()));
    }
  }
}
