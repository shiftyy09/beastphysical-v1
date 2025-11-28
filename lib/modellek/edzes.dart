import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beast_physical/modellek/gyakorlat.dart';

class Edzes {
  String? id; // Opcionális, a Firestore dokumentum azonosítója
  String nev;
  Timestamp datum;
  Duration duration; // Új mező az edzés időtartamának tárolására
  List<Gyakorlat> gyakorlatok;

  Edzes({
    this.id,
    required this.nev,
    required this.datum,
    required this.duration, // Hozzáadva a konstruktorhoz
    required this.gyakorlatok,
  });

  // Firebase-ből való olvasáshoz
  factory Edzes.fromMap(Map<String, dynamic> data, String documentId) {
    var gyakorlatokList = data['gyakorlatok'] as List<dynamic>?;
    List<Gyakorlat> gyakorlatokObj = gyakorlatokList != null
        ? gyakorlatokList.map((gyakorlatData) => Gyakorlat.fromMap(gyakorlatData as Map<String, dynamic>)).toList()
        : [];

    // Időtartam lekérése int-ként, majd átalakítása Duration-né
    final durationInMilliseconds = data['duration'] as int? ?? 0;

    return Edzes(
      id: documentId,
      nev: data['nev'] as String,
      datum: data['datum'] as Timestamp,
      duration: Duration(milliseconds: durationInMilliseconds),
      gyakorlatok: gyakorlatokObj,
    );
  }

  // Firebase-be való íráshoz
  Map<String, dynamic> toMap() {
    return {
      'nev': nev,
      'datum': datum,
      'duration': duration.inMilliseconds, // Duration tárolása milliszekundumban
      'gyakorlatok': gyakorlatok.map((gyakorlat) => gyakorlat.toMap()).toList(),
    };
  }
}
