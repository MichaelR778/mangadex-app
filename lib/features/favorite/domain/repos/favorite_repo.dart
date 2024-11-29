abstract class FavoriteRepo {
  Stream<List<String>> getFavorites();
  Future<void> toggleFavorite(String mangaId);
}
