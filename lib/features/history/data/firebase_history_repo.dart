import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangadex_app/features/history/domain/history_repo.dart';

class FirebaseHistoryRepo implements HistoryRepo {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<List<String>> getHistory() {
    try {
      final stream = firebaseFirestore
          .collection('History')
          .orderBy('time', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
      return stream;
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }

  @override
  Future<void> addHistory(String mangaId) async {
    try {
      await firebaseFirestore
          .collection('History')
          .doc(mangaId)
          .set({'time': Timestamp.fromDate(DateTime.now())});
    } catch (e) {
      throw Exception('Failed to add history: $e');
    }
  }
}
