abstract class HistoryRepo {
  Stream<List<String>> getHistory();
  Future<void> addHistory(String mangaId);
}
