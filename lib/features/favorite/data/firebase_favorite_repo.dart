import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangadex_app/features/favorite/domain/repos/favorite_repo.dart';

class FirebaseFavoriteRepo implements FavoriteRepo {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<List<String>> getFavorites() {
    try {
      final stream = firebaseFirestore
          .collection('Favorites')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
      return stream;
    } catch (e) {
      throw Exception('Failed to get favorite mangas: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String mangaId) async {
    try {
      final favoriteDoc =
          await firebaseFirestore.collection('Favorites').doc(mangaId).get();

      // remove from favorite
      if (favoriteDoc.exists) {
        favoriteDoc.reference.delete(); //await?
      }

      // add to favorite
      else {
        final favorites = await firebaseFirestore.collection('Favorites').get();
        final favCount = favorites.docs.length;
        if (favCount < 100) {
          firebaseFirestore
              .collection('Favorites')
              .doc(mangaId)
              .set({}); //await?
        } else {
          throw Exception('Max favorite manga reached (100 is the max)');
        }
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }
}
