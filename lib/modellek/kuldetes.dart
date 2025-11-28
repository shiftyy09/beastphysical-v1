import 'package:cloud_firestore/cloud_firestore.dart';

class Kuldetes {
  final String id; // A küldetés egyedi azonosítója (pl. egy dokumentum ID a Firestore-ban)
  final String nev;
  final String leiras;
  final String targetWorkoutName; // A cél edzés neve, amit teljesíteni kell (pl. "Mell", "Láb")
  bool teljesitve; // Jelzi, hogy a küldetés teljesítve van-e
  bool aktiv; // Jelzi, hogy a küldetés jelenleg aktív-e a felhasználó számára
  Timestamp? activatedDate; // Mikor lett aktiválva a küldetés
  Timestamp? completedDate; // Mikor lett teljesítve a küldetés

  Kuldetes({
    required this.id,
    required this.nev,
    required this.leiras,
    required this.targetWorkoutName,
    this.teljesitve = false,
    this.aktiv = false,
    this.activatedDate,
    this.completedDate,
  });

  // Firebase-ből való olvasáshoz
  factory Kuldetes.fromMap(Map<String, dynamic> data, String documentId) {
    return Kuldetes(
      id: documentId,
      nev: data['nev'] as String,
      leiras: data['leiras'] as String,
      targetWorkoutName: data['targetWorkoutName'] as String,
      teljesitve: data['teljesitve'] as bool? ?? false,
      aktiv: data['aktiv'] as bool? ?? false,
      activatedDate: data['activatedDate'] as Timestamp?,
      completedDate: data['completedDate'] as Timestamp?,
    );
  }

  // Firebase-be való íráshoz
  Map<String, dynamic> toMap() {
    return {
      'nev': nev,
      'leiras': leiras,
      'targetWorkoutName': targetWorkoutName,
      'teljesitve': teljesitve,
      'aktiv': aktiv,
      'activatedDate': activatedDate,
      'completedDate': completedDate,
    };
  }
}
