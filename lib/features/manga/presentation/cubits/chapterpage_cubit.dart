import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapterpage_state.dart';

class ChapterpageCubit extends Cubit<ChapterpageState> {
  final MangaRepo mangaRepo;

  ChapterpageCubit({required this.mangaRepo}) : super(ChapterpageLoading());

  Future<void> getChapterImageUrls(String chapterId) async {
    try {
      emit(ChapterpageLoading());
      final imageUrls = await mangaRepo.getChapterImageUrls(chapterId);
      emit(ChapterpageLoaded(imageUrls: imageUrls));
    } catch (e) {
      emit(ChapterpageError(message: e.toString()));
    }
  }
}
