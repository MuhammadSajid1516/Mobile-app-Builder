import 'package:firebase_database/firebase_database.dart';
import '../models/sales_model.dart';

class SalesService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child("sales");

  Future<void> addSale(Sale sale) async {
    await _db.child(sale.id).set(sale.toMap());
  }

  Future<void> deleteSale(String id) async {
    await _db.child(id).remove();
  }

  Future<void> updateSale(Sale sale) async {
    await _db.child(sale.id).update(sale.toMap());
  }

  Stream<List<Sale>> getSales() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <Sale>[];
      }

      final Map<dynamic, dynamic> salesMap = Map<dynamic, dynamic>.from(
        data as Map,
      );

      return salesMap.entries.map((entry) {
        return Sale.fromMap(Map<dynamic, dynamic>.from(entry.value));
      }).toList();
    });
  }
}
