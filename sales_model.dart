class Sale {
  String id;
  String customerName;
  String fishType;
  String quantitySold;
  String price;
  String saleDate;

  Sale({
    required this.id,
    required this.customerName,
    required this.fishType,
    required this.quantitySold,
    required this.price,
    required this.saleDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'fishType': fishType,
      'quantitySold': quantitySold,
      'price': price,
      'saleDate': saleDate,
    };
  }

  factory Sale.fromMap(Map<dynamic, dynamic> map) {
    return Sale(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      fishType: map['fishType'] ?? '',
      quantitySold: map['quantitySold'] ?? '',
      price: map['price'] ?? '',
      saleDate: map['saleDate'] ?? '',
    );
  }
}
