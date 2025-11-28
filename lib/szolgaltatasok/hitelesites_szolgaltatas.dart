import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HitelesitesSzolgaltatas {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Jelenlegi felhasználó lekérése
  User? get jelenlegiFelhasznalo => _firebaseAuth.currentUser;

  // Felhasználó állapot figyelése
  Stream<User?> get felhasznaloValtozas => _firebaseAuth.authStateChanges();

  // Bejelentkezés Google fiókkal
  Future<UserCredential?> bejelentkezesGoogle() async {
    try {
      // 1. Google bejelentkezés indítása
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null; // A felhasználó megszakította

      // 2. Hitelesítési adatok lekérése
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Új hitelesítési "credential" készítése
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Bejelentkezés Firebase-be
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("Hiba a Google bejelentkezés során: $e");
      return null;
    }
  }

  // Bejelentkezés vendégként (anonim)
  Future<UserCredential?> bejelentkezesVendegkent() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } catch (e) {
      print("Hiba az anonim bejelentkezés során: $e");
      return null;
    }
  }

  // Kijelentkezés
  Future<void> kijelentkezes() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
