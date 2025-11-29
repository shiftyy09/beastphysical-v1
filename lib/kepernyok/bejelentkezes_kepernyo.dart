import 'package:flutter/material.dart';
import '../szolgaltatasok/hitelesites_szolgaltatas.dart';

class BejelentkezesKepernyo extends StatefulWidget {
  const BejelentkezesKepernyo({super.key});

  @override
  State<BejelentkezesKepernyo> createState() => _BejelentkezesKepernyoState();
}

class _BejelentkezesKepernyoState extends State<BejelentkezesKepernyo> {
  bool _betoltesAlatt = false;

  Future<void> _googleBejelentkezes() async {
    if (_betoltesAlatt) return; // Megakadályozza a duplakattintást

    setState(() {
      _betoltesAlatt = true;
    });

    final szerviz = HitelesitesSzolgaltatas();
    final eredmeny = await szerviz.bejelentkezesGoogle();

    if (mounted) {
      setState(() {
        _betoltesAlatt = false;
      });
      
      if (eredmeny == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A Google bejelentkezés sikertelen volt.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Háttérkép
          Positioned.fill(
            child: Image.asset(
              'assets/images/bejelentkezes_hatter.png', // A te általad készített háttérkép
              fit: BoxFit.cover,
            ),
          ),
          // Tartalom (Gomb a képernyő alján)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Alulra igazítjuk
                children: [
                  if (_betoltesAlatt)
                    const CircularProgressIndicator(color: Colors.white) // Fehér betöltésjelző
                  else
                    // Google bejelentkezés gomb - Turbózott stílus
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB71C1C), Color(0xFFC62828)], // Mélyebb vörös/bordó gradiens
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB71C1C).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _googleBejelentkezes, // Függvény hívása
                          borderRadius: BorderRadius.circular(30),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.login, color: Colors.white), // Fehér ikon
                                SizedBox(width: 12),
                                Text(
                                  'BEJELENTKEZÉS GOOGLE',
                                  style: TextStyle(
                                    color: Colors.white, // Fehér szöveg
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 48), // Gomb alatt kis térköz
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
