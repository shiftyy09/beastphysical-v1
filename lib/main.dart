import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'kepernyok/indulo_kepernyo.dart';
import 'tema/alkalmazas_tema.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('=== APP INDULÁSA ===');
  try {
    debugPrint('Firebase inicializálása...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase sikeresen inicializálva');
  } catch (e) {
    debugPrint('Firebase init hiba: $e');
  }
  debugPrint('=== APP FUTÁSA ===');
  runApp(const BeastPhysicalAlkalmazas());
}

class BeastPhysicalAlkalmazas extends StatefulWidget {
  const BeastPhysicalAlkalmazas({super.key});

  @override
  State<BeastPhysicalAlkalmazas> createState() =>
      _BeastPhysicalAlkalmazasState();
}

class _BeastPhysicalAlkalmazasState extends State<BeastPhysicalAlkalmazas> {
  bool _vilagTema = false;

  void _atvaltoTema() {
    setState(() {
      _vilagTema = !_vilagTema;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MaterialApp felépítése - Téma: ${_vilagTema ? "VILÁGOS" : "SÖTÉT"}');

    return MaterialApp(
      title: 'BeastPhysical',
      debugShowCheckedModeBanner: false,
      theme: _vilagTema ? AlkalmazasTema.vilagTema : AlkalmazasTema.sotetTema,
      home: InduloKepernyo(
        atvaltoTema: _atvaltoTema,
        vilagTema: _vilagTema,
      ),
    );
  }
}
