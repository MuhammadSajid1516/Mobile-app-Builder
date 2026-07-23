import 'package:firebase_database/firebase_database.dart';
import '../models/feed_model.dart';

class FeedService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child("feeds");

  Future<void> addFeed(Feed feed) async {
    await _db.child(feed.id).set(feed.toMap());
  }

  Future<void> deleteFeed(String id) async {
    await _db.child(id).remove();
  }

  Future<void> updateFeed(Feed feed) async {
    await _db.child(feed.id).update(feed.toMap());
  }

  Stream<List<Feed>> getFeeds() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <Feed>[];
      }

      final Map<dynamic, dynamic> feedMap = Map<dynamic, dynamic>.from(
        data as Map,
      );

      return feedMap.entries.map((entry) {
        return Feed.fromMap(Map<dynamic, dynamic>.from(entry.value));
      }).toList();
    });
  }
}
