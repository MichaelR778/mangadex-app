import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/history/domain/history_repo.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_state.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepo historyRepo;
  final MangaRepo mangaRepo;
  StreamSubscription? historySubscription;

  HistoryCubit({
    required this.historyRepo,
    required this.mangaRepo,
  }) : super(HistoryLoading());

  void init() => loadHistory();

  Future<void> loadHistory() async {
    try {
      print('INIT GOT CALLED');
      emit(HistoryLoading());

      historySubscription?.cancel();

      historySubscription = historyRepo.getHistory().listen(
        (mangaIds) async {
          try {
            if (mangaIds.isEmpty) {
              emit(HistoryLoaded(mangas: []));
              return;
            }
            if (mangaIds.length > 100) mangaIds = mangaIds.sublist(0, 100);
            final mangas = await mangaRepo.getMangas(mangaIds);
            final sorted = mangaIds
                .map((id) => mangas.firstWhere((manga) => id == manga.id))
                .toList();
            emit(HistoryLoaded(mangas: sorted));
          } catch (e) {
            emit(HistoryError(message: e.toString()));
          }
        },
        onError: (error) {
          emit(HistoryError(message: error.toString()));
        },
        cancelOnError: true,
      );
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }

  Future<void> addHistory(String mangaId) async {
    try {
      historyRepo.addHistory(mangaId);
    } catch (e) {
      emit(HistoryError(message: e.toString()));
      loadHistory();
    }
  }
}
