class Szett {
  double suly;
  int ismetlesek;
  bool befejezett;

  Szett({
    required this.suly,
    required this.ismetlesek,
    this.befejezett = false,
  });

  // Firebase-ből való olvasáshoz
  factory Szett.fromMap(Map<String, dynamic> data) {
    return Szett(
      suly: (data['suly'] as num).toDouble(),
      ismetlesek: data['ismetlesek'] as int,
      befejezett: data['befejezett'] as bool,
    );
  }

  // Firebase-be való íráshoz
  Map<String, dynamic> toMap() {
    return {
      'suly': suly,
      'ismetlesek': ismetlesek,
      'befejezett': befejezett,
    };
  }
}
