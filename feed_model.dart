class Feed {
  String id;
  String feedName;
  String feedType;
  String quantity;
  String cost;
  String purchaseDate;

  Feed({
    required this.id,
    required this.feedName,
    required this.feedType,
    required this.quantity,
    required this.cost,
    required this.purchaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedName': feedName,
      'feedType': feedType,
      'quantity': quantity,
      'cost': cost,
      'purchaseDate': purchaseDate,
    };
  }

  factory Feed.fromMap(Map<dynamic, dynamic> map) {
    return Feed(
      id: map['id'] ?? '',
      feedName: map['feedName'] ?? '',
      feedType: map['feedType'] ?? '',
      quantity: map['quantity'] ?? '',
      cost: map['cost'] ?? '',
      purchaseDate: map['purchaseDate'] ?? '',
    );
  }
}
