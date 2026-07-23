import 'package:firebase_database/firebase_database.dart';
import '../models/pond_model.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child("ponds");

  // Add Pond
  Future<void> addPond(Pond pond) async {
    await _db.child(pond.id).set(pond.toMap());
  }

  // Delete Pond
  Future<void> deletePond(String id) async {
    await _db.child(id).remove();
  }

  // Update Pond
  Future<void> updatePond(Pond pond) async {
    await _db.child(pond.id).update(pond.toMap());
  }

  // Get All Ponds
  Stream<List<Pond>> getPonds() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <Pond>[];
      }

      final Map<dynamic, dynamic> pondsMap = Map<dynamic, dynamic>.from(
        data as Map,
      );

      return pondsMap.entries.map((entry) {
        return Pond.fromMap(Map<dynamic, dynamic>.from(entry.value));
      }).toList();
    });
  }

  // Total Pond Count
  Stream<int> getPondCount() {
    return getPonds().map((ponds) => ponds.length);
  }

  // Total Fish Count
  Stream<int> getTotalFishCount() {
    return getPonds().map((ponds) {
      int totalFish = 0;

      for (var pond in ponds) {
        totalFish += int.tryParse(pond.fishQuantity) ?? 0;
      }

      return totalFish;
    });
  }
}
