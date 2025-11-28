import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../szolgaltatasok/hitelesites_szolgaltatas.dart';
import 'navigacio_kezelo.dart';
import 'bejelentkezes_kepernyo.dart';
import '../tema/theme_controller.dart';

class HitelesitesEllenorzo extends StatelessWidget {
  final Function? atvaltoTema;
  final bool vilagTema;

  const HitelesitesEllenorzo({
    super.key,
    this.atvaltoTema,
    this.vilagTema = false,
  });

  @override
  Widget build(BuildContext context) {
    final szerviz = HitelesitesSzolgaltatas();
    
    return StreamBuilder<User?>(
      stream: szerviz.felhasznaloValtozas,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NavigacioKezelo(
            atvaltoTema: () => toggleTheme(),
          );
        }
        return BejelentkezesKepernyo(
          atvaltoTema: () => toggleTheme(),
        );
      },
    );
  }
}
