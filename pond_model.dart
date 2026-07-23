class Pond {
  String id;
  String pondName;
  String fishType;
  String fishQuantity;
  String feedType;
  String dailyFeedQuantity;

  Pond({
    required this.id,
    required this.pondName,
    required this.fishType,
    required this.fishQuantity,
    required this.feedType,
    required this.dailyFeedQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pondName': pondName,
      'fishType': fishType,
      'fishQuantity': fishQuantity,
      'feedType': feedType,
      'dailyFeedQuantity': dailyFeedQuantity,
    };
  }

  factory Pond.fromMap(Map<dynamic, dynamic> map) {
    return Pond(
      id: map['id'] ?? '',
      pondName: map['pondName'] ?? '',
      fishType: map['fishType'] ?? '',
      fishQuantity: map['fishQuantity'] ?? '',
      feedType: map['feedType'] ?? '',
      dailyFeedQuantity: map['dailyFeedQuantity'] ?? '',
    );
  }
}
